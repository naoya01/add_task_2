class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update]
  before_action :authenticate_user!, only: [:show]
  def show
    @user = User.find(params[:id])
    @books = @user.books.all
    @book = Book.new

    @currentUserEntry=Entry.where(user_id: current_user.id)
    @userEntry=Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      unless @isRoom
        @room = Room.new
        @entry = Entry.new
      end
    end

    # to  = Time.current.at_end_of_day #今日の23:59の日時を取得 (toは任意)#
    # from  = (to - 6.day).at_beginning_of_day #6日前の0:00の日時取得 (fromは任意)#
    # @books = Book.includes(:favorites).sort {|a,b|
    #     b.favorites.includes(:favorites).where(created_at: from...to).size <=>
    #     a.favorites.includes(:favorites).where(created_at: from...to).size
    #   }
      now = Time.current
      @today = now.all_day #今日
      @yesterday = 1.day.ago.all_day #昨日
      @week = now.all_week #今週
      @weekego = 1.week.ago.all_week #先週

  end

  def index

    @users = User.all
    @user = current_user
    @book = Book.new

  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      @books = Book.all
      render "show"
    end
  end


  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def search
    @user = User.find(params[:user_id])
    @books = @user.books 
    @book = Book.new
    if params[:created_at] == ""
      @search_book = "日付を選択してください"#①
    else
      create_at = params[:created_at]
      @search_book = @books.where(['created_at LIKE ? ', "#{create_at}%"]).count#②
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
