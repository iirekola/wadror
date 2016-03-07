class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id if not user.nil?
      redirect_to user, notice: "Welcome back!"
    else
      redirect_to :back, notice: "Username and/or password mismatch"
    end
  end

  def create_oauth
    nickname = env["omniauth.auth"]['info']['nickname']
    redirect_to :back, notice: "Couldn't authenticate you" if nickname.nil?

    user = User.find_by username: nickname
    if user.nil?
      user = User.new username: nickname, login_mode: "GitHub"
      user.save validate: false
    end

    session[:user_id] = user.id
    redirect_to user, notice: "Welcome back!"
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end