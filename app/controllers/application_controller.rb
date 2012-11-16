class ApplicationController < ActionController::Base

  protect_from_forgery

  protected

  def confirm_logged_in
    if session[:user_id]
      return true
    else
      flash[:notice] = "Please login."
      redirect_to(:controller => 'authentications', :action => 'login')
      return false # halts the before_filter
    end
  end

end
