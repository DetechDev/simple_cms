class ApplicationController < ActionController::Base

  protect_from_forgery

  protected

  def confirm_logged_in
    unless session[:user_id]
      flash[:notice] = "Please login."
      redirect_to(:controller => 'authentications', :action => 'login')
      return false # halts the before_filter
    else
      return true
    end
  end

end
