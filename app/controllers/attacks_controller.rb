class AttacksController < ApplicationController

  def new

    @attack = Attack.new
    @group = Group.find(params[:group_id])
    @turn_num = params[:turn_num]
    if @turn_num.to_i == 1
      @turn = Turn.find(params[:id])  
    elsif @turn_num.to_i >= 200 && @turn_num.to_i <= 299
      redirect_to root_path
    elsif @turn_num.to_i >= 1000
      redirect_to root_path
    else  
      @turn = Turn.new(group_id: @group.id,turn_num: @turn_num)
      @turn.save
    end
  end
  
  def create
    @attack = Attack.new(right: params[:right],left: params[:left],call: params[:call],turn_id: params[:turn_id],turn_num: params[:turn_num],user_id: params[:user_id])
    if @attack.save
      @turn = Turn.find(params[:id])
      @turn.update(attack_id: @attack.id)
      @group = Group.find(params[:group_id])
      redirect_to attacks_show_path(@group,@turn.id,@turn.turn_num)
    else
      flash[:notice] = "sippai" 
      redirect_to root_path

    end  
  end  

  def show
    @group = Group.find(params[:group_id])
    @turn = Turn.find(params[:id])
    @attack = Attack.find(@turn.attack_id)
  end  
end
