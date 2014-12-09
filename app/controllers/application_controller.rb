class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def check_signed_in
    unless signed_in?
      flash[:error] = "Please login to use the app !!"
      redirect_to root_url
    end
  end

  def signed_in?
    !current_user.nil?
  end

  def check_authorized
    if current_user != FileUpload.find(params[:id]).user
      flash[:error] = "No such file found or Authorization Error"
      redirect_to action: "index" and return
    end
  end
end

