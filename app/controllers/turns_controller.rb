class TurnsController < ApplicationController
  def new
    @turn = Turn.new
    @group = Group.find(params[:group_id])
    @owner = @group.users[0]
    @visiter = @group.users[1]
    @turns = Turn.where(group_id: params[:group_id])
    @turn_get = @turns[0]
    if current_user.id == @visiter.id && @turns.length >= 1
      redirect_to defences_new_path(@group,@turn_get.id,@turn_get.turn_num)
    end
  end
  
  def create
    @group = Group.find(params[:group_id])
    @owner = @group.users[0]
    @visiter = @group.users[1]
    @turn = Turn.new(turn_params)
    if @turn.save && current_user.id == @owner.id
      redirect_to attacks_new_path(@group,@turn.id,@turn.turn_num)
    else 
      redirect_to root_path
    end
  end

  def result
    @group = Group.find(params[:group_id])
    @turn = Turn.find(params[:id])
    @owner = @group.users[0]
    @visiter = @group.users[1]
    @attacks = @turn.attack_id
    @defences = @turn.defence_id
    @turn_num = @turn.turn_num.to_i
    

    @attack = Attack.find_by(id: @attacks)
    @defence = Defence.find_by(id: @defences)

    @next_turn = @turn.id.to_i + 1

    @attackresult = @attack.right.to_i + @attack.left.to_i
    @defenceresult = @defence.right.to_i + @defence.left.to_i
    @total = @attackresult.to_i + @defenceresult.to_i
    if @total == @attack.call.to_i && @attack.user == @owner
      @result = "あたり"
      @turn_num_next = @turn_num + 101
    elsif @total == @attack.call.to_i && @attack.user == @visiter
      @result = "あたり"
      @turn_num_next = @turn_num + 501
    else
      @result = "はずれ"
      @turn_num_next = @turn_num + 1
    end

    @next_turn_made = Turn.find_by(group_id: @group.id,turn_num: @turn_num_next)

    if @next_turn_made != nil && current_user.id.to_i == @attack.user_id.to_i && current_user.id == @visiter.id
      redirect_to defences_new_path(@group,@next_turn,@turn_num_next)
    elsif  @next_turn_made != nil && current_user.id.to_i == @defence.user_id.to_i && current_user.id == @visiter.id
      redirect_to attacks_new_path(@group,@next_turn,@turn_num_next)
    end    

    
    if @turn_num_next.to_i >= 200 && @turn_num_next.to_i <= 299 && current_user == @owner
      redirect_to turns_win_path(@group,1,@turn_num_next)
    elsif @turn_num_next.to_i >= 200 && @turn_num_next.to_i <= 299 && current_user == @visiter
      redirect_to turns_lose_path(@group,1,@turn_num_next)
    elsif @turn_num_next.to_i >= 700 && @turn_num_next.to_i <= 799 && current_user == @owner
      redirect_to turns_win_path(@group,1,@turn_num_next)
    elsif @turn_num_next.to_i >= 700 && @turn_num_next.to_i <= 799 && current_user == @visiter
      redirect_to turns_lose_path(@group,1,@turn_num_next)    
    elsif @turn_num_next.to_i >= 1000 && current_user == @visiter
      redirect_to turns_win_path(@group,1,@turn_num_next)
    elsif @turn_num_next.to_i >= 1000 && current_user == @owner
      redirect_to turns_lose_path(@group,1,@turn_num_next)
    end

    # @turns.each do |turn|
    #   if turn.attack_id != nil
    #     @turn_attack_num = turn.id
    #     @attacks = turn.attack_id.to_i
    #     @turn_num = turn.turn_num.to_i
    #   end  
    # end
    # @turns.each do |turn|

    #   if turn.defence != nil
    #     @turn_defence_num = turn.id
    #     @defences = turn.defence_id.to_i
    #     @turn_num = turn.turn_num.to_i
    #   end  
    # end
    
    

    # @nil_turns = Turn.where(attack_id: nil).where(defence_id: nil)
    # if @nil_turns.length >= 1
    #   @nil_turns.each do |turn|
    #   turn.destroy
    #   end  
    # end  
    
  end
  
  def win
    @group = Group.find_by(id: params[:group_id])
    if @group == nil
      redirect_to root_path
    end
  end
  
  def lose
    @group = Group.find_by(id: params[:group_id])
    if @group == nil
      redirect_to root_path
    end
  end

  private

  def turn_params
    params.require(:turn).permit(:turn_num,:group_id,user_ids: [])
  end

end
