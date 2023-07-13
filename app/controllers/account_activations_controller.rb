class AccountActivationsController < ApplicationController
  before_action :load_user, only: :edit

  def edit
    if !@user.activated? && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash[:success] = t "account_activation.activated"
      redirect_to @user
    else
      flash[:danger] = t "account_activation.invalid"
      redirect_to root_path
    end
  end

  private

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to root_url
  end
end
