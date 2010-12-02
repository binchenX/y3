class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def login_required
    if session[:user]
      return true
    end
    flash[:warning]='Please login to continue'
    session[:return_to] = request.request_uri
    redirect_to :controller => "user", :action => "login"
    return false
  end

  def current_user_is_admin
      return current_user && current_user.login.eql?("pierr")
  end

  helper_method :current_user
  helper_method :current_user_is_admin

  def current_user_is_admin
      return current_user && current_user.login.eql?("pierr")
  end
  
   def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end

  def redirect_to_stored
    if return_to = session[:return_to]
      session[:return_to]=nil
      redirect_to(return_to)
    else
      redirect_to :controller=>'user', :action=>'welcome'
    end
  end

end
