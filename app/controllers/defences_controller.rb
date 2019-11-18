class DefencesController < ApplicationController
  def new
    @defence = Defence.new
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
    @defence = Defence.new(right: params[:right],left: params[:left],turn_id: params[:turn_id],turn_num: params[:turn_num],user_id: params[:user_id])
    if @defence.save
      @turn = Turn.find(params[:id])
      @turn.update(defence_id: @defence.id)
      @group = Group.find(params[:group_id])
      redirect_to defences_show_path(@group,@turn.id,@turn.turn_num)
    else
      flash[:notice] = "sippai" 
      redirect_to root_path

    end  
  end

  def show
    @turns = Turn.where(group_id: params[:group_id]).where(turn_num: params[:turn_num])
    @group = Group.find(params[:group_id])
    @turn = Turn.find(params[:id])
    @defence = Defence.find(@turn.defence_id) 
    if @turns[0].attack_id != nil && @turns[1].defence_id != nil
      redirect_to turns_result_path(@group,@turn)
    elsif @turns[1].attack_id != nil && @turns[0].defence_id != nil
      redirect_to turns_result_path(@group,@turn)
    elsif @turns[1].attack_id != nil && @turns[3].defence_id != nil
      redirect_to turns_result_path(@group,@turn)
    elsif @turns[1].defence_id != nil && @turns[1].attack_id != nil
      redirect_to turns_result_path(@group,@turn)  
    else  
      @notice = "相手待ちです"   
    end    
      
  end
end
