class GroupsController < ApplicationController
  before_action :set_group, only: [:edit, :update]

  def index
    @users = User.all
    @user = current_user
    @book = Book.new
    @group = Group.new
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    @groups = Group.find_by(params[:group_id])
    @users = @groups.users
    @user = current_user
    @book = Book.new

  end

  def new
    @group = Group.new
    @users = User.all
    @book = Book.new
    @user = current_user
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      @group.users << current_user
      redirect_to groups_path, notice: 'グループを作成しました'
    else
      render :new
    end
  end

  def join #追記！
    @group = Group.find(params[:group_id])
    @group.users << current_user
    redirect_to  group_path(@group)
  end

  def edit
    @groups = Group.find(params[:id])
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path, notice: 'グループを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @book.delete
  end

  def leave
    @group = Group.find(params[:group_id])
    @group_user = @group.group_users.find_by(user_id: current_user)
    @group_user.delete
    redirect_to  group_path(@group)
  end

  def new_mail
    @group = Group.find(params[:group_id])
  end

  def send_mail
    @group = Group.find(params[:group_id])
    group_users = @group.users
    @mail_title = params[:mail_title]
    @mail_content = params[:mail_content]
    ContactMailer.send_mail(@mail_title, @mail_content,group_users).deliver
  end

  private
  def group_params
    params.require(:group).permit(:name,:image,:introduction,:owner_id,user_ids: [])
  end

  def set_group # ここ3
    @group = Group.find(params[:id])
  end
end
