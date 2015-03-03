class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    unless logged_in?
      flash[:error] = "You must be logged in"
      redirect_to root_path
    end
  end

  def access_denied
    flash[:error] = "You do not have permission to perform that action"
    redirect_to tasks_path
  end

  def set_outstanding_and_completed_tasks
    @tasks_outstanding = @tasks.select { |task| !task.completed }
    @tasks_completed = @tasks.select { |task| task.completed }
  end
end
