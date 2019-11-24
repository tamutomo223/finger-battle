class GroupsController < ApplicationController
  before_action :set_group, only: [:update]

  def index
    @groups = Group.all.order(created_at: "desc")
  end

  def new
    @group = Group.new
    @group.users << current_user
  end  

  def create
    @group = Group.new(group_params)
    if @group.save
      flash[:notice] = "グループを作成しました"
      redirect_to group_path(@group)
    elsif @group.name == ""
      flash[:notice] = "文字を入力してください"
      render :new
    else
      flash[:notice] = "重複しています"  
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])
    if @group.users.length == 2 && user_signed_in?
      redirect_to new_turn_path(@group)
    end  
  end

  def update
    if @group.update(group_params)
      flash[:notice] = "グループに参加しました"
      redirect_to group_path(@group)
    else
      flash[:notice] = "グループに参加できませんでした"
      redirect_to group_path(@group)
    end  
  end  

  def destroy
    @group = Group.find(params[:group_id])
    @group.destroy
    redirect_to root_path
  end

  private

  def group_params
    params.require(:group).permit(:name,user_ids: [])
  end

  def set_group
    @group = Group.find(params[:id])
  end
end
