class DefencesController < ApplicationController
  def new
    @defence = Defence.new
    @group = Group.find(params[:group_id])
    @owner = @group.users[0]
    @visiter = @group.users[1]
    @turn_num = params[:turn_num]
    @turn_made = Turn.find_by(group_id: @group.id,turn_num: @turn_num)
    
    if @turn_num.to_i == 1
      @turn = Turn.find(params[:id])  
    elsif @turn_num.to_i >= 200 && @turn_num.to_i <= 299
      redirect_to root_path
    elsif @turn_num.to_i >= 1000
      redirect_to root_path
    elsif current_user.id == @owner.id && @turn_made == nil
      @turn_new = Turn.new(group_id: @group.id,turn_num: @turn_num)
      @turn_new.save
      @turn = Turn.find(@turn_new.id)
    end
    @turn = Turn.find(params[:id])
    
  end
  
  def create
    @defence = Defence.new(right: params[:right],left: params[:left],turn_id: params[:turn_id],turn_num: params[:turn_num],user_id: params[:user_id])
    if @defence.save
      @turn = Turn.find(params[:id])
      @turn.update(defence_id: @defence.id)
      @group = Group.find(params[:group_id])
      redirect_to defences_show_path(@group,@turn,@turn.turn_num)
    else
      flash[:notice] = "sippai" 
      redirect_to root_path

    end  
  end

  def show
    @group = Group.find(params[:group_id])
    @turn = Turn.find(params[:id])
    if @turn.attack_id != nil && @turn.defence_id != nil
      redirect_to turns_result_path(@group,@turn,@turn.turn_num)
    else  
      @notice = "相手待ちです"
    end    
      
  end
end
