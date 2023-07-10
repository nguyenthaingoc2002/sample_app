class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase

    if user&.authenticate params[:session][:password]
      log_in user
      handle_remember user
      redirect_to user
    else
      flash.now[:danger] = t "login.invalid_email_password_combination"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end