class TurnsController < ApplicationController

  before_action :set_group, only: [:create,:result]
  before_action :group_nil, only: [:new,:win,:lose]

  def new
    #試合開始時の最初のターン作成
    @turn = Turn.new
    @owner = @group.users[0]
    @visiter = @group.users[1]

    #グループidと一致しているターンがあるか確認
    @turns = Turn.where(group_id: params[:group_id])
    #そのターンの先頭を取得
    @turn_get = @turns[0]
    #
    if current_user.id == @visiter.id && @turns.length >= 1
      redirect_to defences_new_path(@group,@turn_get.id,@turn_get.turn_num)
    end
  end
  
  def create
    @turn = Turn.new(turn_params)
    if @turn.save && current_user.id == @owner.id
      redirect_to attacks_new_path(@group,@turn.id,@turn.turn_num)
    else 
      redirect_to root_path
    end
  end

  def result
    #事前準備
    @turn = Turn.find(params[:id])
    @attacks = @turn.attack_id
    @defences = @turn.defence_id
    @turn_num = @turn.turn_num.to_i

    #攻撃、防御それぞれ対応レコードを取得
    @attack = Attack.find_by(id: @attacks)
    @defence = Defence.find_by(id: @defences)

    #次のターンidを作成
    @next_turn = @turn.id.to_i + 1

    #攻撃、防御それぞれのあげた指の数を計算
    @attackresult = @attack.right.to_i + @attack.left.to_i
    @defenceresult = @defence.right.to_i + @defence.left.to_i

    #合わせた数を@totalに代入
    @total = @attackresult.to_i + @defenceresult.to_i

    #オーナーかビジターのどっちが当たったか、外れたかで、urlに付与する番号を変える
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

    #オーナーによって次のターンが生成されてるか確認
    @next_turn_made = Turn.find_by(group_id: @group.id,turn_num: @turn_num_next)

    #ビジターはオーナーによって、次のターンが生成されていれば自動で攻撃または防御ページに移動する
    if @next_turn_made != nil && current_user.id.to_i == @attack.user_id.to_i && current_user.id == @visiter.id
      redirect_to defences_new_path(@group,@next_turn,@turn_num_next)
    elsif  @next_turn_made != nil && current_user.id.to_i == @defence.user_id.to_i && current_user.id == @visiter.id
      redirect_to attacks_new_path(@group,@next_turn,@turn_num_next)
    end

    #urlに付与された番号がどちらかの勝利条件に当てはまっていれば、それぞれ勝ちページと負けページへ飛ばす
    if @turn_num_next.to_i >= 200 && @turn_num_next.to_i <= 299 && current_user == @owner
      @user = User.find(current_user.id)
      @current_win = @user.win
      @update_win = @current_win.to_i + 1
      @user.update(win:@update_win)
      redirect_to turns_win_path(@group,1,@turn_num_next)
    elsif @turn_num_next.to_i >= 200 && @turn_num_next.to_i <= 299 && current_user == @visiter
      @user = User.find(current_user.id)
      @current_lose = @user.lose
      @update_lose = @current_lose.to_i + 1
      @user.update(lose:@update_lose)
      redirect_to turns_lose_path(@group,1,@turn_num_next)
    elsif @turn_num_next.to_i >= 700 && @turn_num_next.to_i <= 799 && current_user == @owner
      @user = User.find(current_user.id)
      @current_win = @user.win
      @update_win = @current_win.to_i + 1
      @user.update(win:@update_win)
      redirect_to turns_win_path(@group,1,@turn_num_next)
    elsif @turn_num_next.to_i >= 700 && @turn_num_next.to_i <= 799 && current_user == @visiter
      @user = User.find(current_user.id)
      @current_lose = @user.lose
      @update_lose = @current_lose.to_i + 1
      @user.update(lose:@update_lose)
      redirect_to turns_lose_path(@group,1,@turn_num_next)    
    elsif @turn_num_next.to_i >= 1000 && current_user == @visiter
      @user = User.find(current_user.id)
      @current_win = @user.win
      @update_win = @current_win.to_i + 1
      @user.update(win:@update_win)
      redirect_to turns_win_path(@group,1,@turn_num_next)
    elsif @turn_num_next.to_i >= 1000 && current_user == @owner
      @user = User.find(current_user.id)
      @current_lose = @user.lose
      @update_lose = @current_lose.to_i + 1
      @user.update(lose:@update_lose)
      redirect_to turns_lose_path(@group,1,@turn_num_next)
    end
  end
  
  def win
  
  end
  
  def lose
    
  end

  def set_group 
    @group = Group.find(params[:group_id])
    @owner = @group.users[0]
    @visiter = @group.users[1]
  end

  def group_nil
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
