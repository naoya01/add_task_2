class RelationshipsController < ApplicationController
  def follows

    @user = User.find(params[:user_id])
    @users = @user.follows

  end

  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers
  end

  def create
    user = User.find(params[:user_id])
    if current_user.follow(user)
       flash[:success] = 'ユーザーをフォローしました'

      redirect_to request.referer
    else
      flash.now[:alert] = 'ユーザーのフォローに失敗しました'
    redirect_to users_path
    end
  end

  def destroy
    user = User.find(params[:user_id])
    # following = current_user.unfollow(user)
    if current_user.unfollow(user)
      flash[:success] = 'ユーザーのフォローを解除しました'
      redirect_to request.referer
    else
      flash.now[:alert] = 'ユーザーのフォロー解除に失敗しました'
      redirect_to books_path
    end
  end


end
