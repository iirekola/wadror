class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.

  # For APIs, you may want to use :null_session instead.


  protect_from_forgery with: :exception


  # m��ritell��n, ett� metodi current_user tulee k�ytt��n my�s n�kymiss�
  helper_method :current_user

  def current_user
    return nil if session[:user_id].nil?
    User.find(session[:user_id])
  end

end
