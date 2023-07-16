class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action{@pagy_locale = params[:locale]}
  around_action :switch_locale
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def switch_locale &action
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "please_login"
    redirect_to login_url
  end
end
