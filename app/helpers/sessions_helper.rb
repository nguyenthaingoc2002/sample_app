module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    if user_id = session[:user_id]
      @current_user ||= User.find_by(id: user_id)
    elsif user_id = cookies.signed[:user_id]
      user = User.find_by id: user_id

      if user&.authenticated? :remember, cookies.signed[:remember_token]
        log_in user
        @current_user = user
      end
    end
  end

  def current_user? user
    user && user == current_user
  end

  def can_delete_user? user
    current_user.admin? && !current_user?(user)
  end

  def handle_remember user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
  end

  def logged_in?
    current_user.present?
  end

  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  def log_out
    forget current_user
    session.delete :user_id
    @current_user = nil
  end

  def redirect_back_or default_route
    redirect_to session[:forwarding_url] || default_route
    session.delete :forwarding_url
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
