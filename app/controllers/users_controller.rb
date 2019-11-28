class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @total = @user.win.to_i + @user.lose.to_i
    @avarage = @user.win.to_i / @total.to_f * 100
    @users = User.all.order(win: "desc")
    @index = @users.index(@user)
    @indexx = @index.to_i + 1
  end 

  def rank
    @users = User.all.order(win: "desc")
    @index = 1
  end  
end

