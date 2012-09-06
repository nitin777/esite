class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    if session[:user_id].nil?
        redirect_to :controller => "sessions", :action => "new"
    end
  end

end
