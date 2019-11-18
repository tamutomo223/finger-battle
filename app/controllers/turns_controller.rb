class TurnsController < ApplicationController
  def new
    @turn = Turn.new
    @group = Group.find(params[:group_id])
    @owner = @group.users[1]
    @visiter = @group.users[0]
  end
  
  def create
    @group = Group.find(params[:group_id])
    @owner = @group.users[1]
    @visiter = @group.users[0]
    @turn = Turn.new(turn_params)
    if @turn.save && current_user == @owner
      redirect_to attacks_new_path(@group,@turn.id,@turn.turn_num)
    elsif @turn.save && current_user == @visiter
      redirect_to defences_new_path(@group,@turn,@turn.turn_num)
    else 
      redirect_to root_path
    end
  end

  def result
    @group = Group.find(params[:group_id])
    @turns = Turn.where(params[:group_id])

    @turns.each do |turn|
      if turn.attack_id != nil
        @turn_attack_num = turn.id
        @attacks = turn.attack_id.to_i
        @turn_num = turn.turn_num.to_i
      end  
    end
    @turns.each do |turn|

      if turn.defence != nil
        @turn_defence_num = turn.id
        @defences = turn.defence_id.to_i
        @turn_num = turn.turn_num.to_i
      end  
    end
    
    @attack = Attack.find_by(id: @attacks)
    @defence = Defence.find_by(id: @defences)

    @nil_turns = Turn.where(attack_id: nil).where(defence_id: nil)
    if @nil_turns.length >= 1
      @nil_turns.each do |turn|
      turn.destroy
      end  
    end  

    @attackresult = @attack.right.to_i + @attack.left.to_i
    @defenceresult = @defence.right.to_i + @defence.left.to_i
    @total = @attackresult.to_i + @defenceresult.to_i
    if @total == @attack.call.to_i && @attack.user == @group.users[0]
      @result = "あたり"
      @turn_num_next = @turn_num + 101
    elsif @total == @attack.call.to_i && @attack.user == @group.users[1]
      @result = "あたり"
      @turn_num_next = @turn_num + 501
    else
      @result = "はずれ"
      @turn_num_next = @turn_num + 1
    end

    @next_turn_attack = @turn_attack_num.to_i + 2
    @next_turn_defence = @turn_defence_num.to_i + 2
    
    if @turn_num_next.to_i >= 200 && @turn_num_next.to_i <= 299 && current_user == @group.users[0]
      redirect_to turns_win_path(@group,1,@turn_num_next)
    elsif @turn_num_next.to_i >= 200 && @turn_num_next.to_i <= 299 && current_user == @group.users[1]
      redirect_to turns_lose_path(@group,1,@turn_num_next)
    elsif @turn_num_next.to_i >= 1000 && current_user == @group.users[1] 
      redirect_to turns_win_path(@group,1,@turn_num_next)
    elsif @turn_num_next.to_i >= 1000 && current_user == @group.users[0] 
      redirect_to turns_lose_path(@group,1,@turn_num_next)
    end

    
    
  end
  
  def win
    @group = Group.find(params[:group_id])
  end
  
  def lose

  end  

  private

  def turn_params
    params.require(:turn).permit(:turn_num,:group_id,user_ids: [])
  end

end
