class GroupsController < ApplicationController
  before_action :set_group, only: [:edit, :update]

  def index
    @users = User.all
    @user = current_user
    @book = Book.new
    @group = Group.new
    @groups = Group.all
  end

  def new
    @group = Group.new
    @users = User.all
    @book = Book.new
    @user = current_user
    # @group.users << current_user
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to groups_path, notice: 'グループを作成しました'
    else
      render :new
    end
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

  private
  def group_params
    params.require(:group).permit(:name,:image,:introduction,:owner_id)
  end

  def set_group # ここ3
    @group = Group.find(params[:id])
  end
end
