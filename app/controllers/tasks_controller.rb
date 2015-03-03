class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :mark_completed]
  before_action :set_tasks, only: [:index, :personal, :assigned]
  before_action :require_user
  before_action :require_creator_or_assignee, only: [:edit, :update, :mark_completed]
  before_action :require_creator_or_group_member, only: [:show]

  def index
    set_outstanding_and_completed_tasks
    @show_assignee = true
    @title = "All tasks"
  end

  def show
  end

  def new
    @task = Task.new
    @selected_users = [current_user]
  end

  def create
    @task = Task.new(task_params)
    @task.creator = current_user

    if @task.save
      flash[:notice] = "Your task has been created"
      redirect_to tasks_path
    else
      set_selected_users
      render "new"
    end
  end

  def edit
    set_selected_users
  end

  def update
    if @task.update(task_params)
      flash[:notice] = "Your task has been updated"
      redirect_to task_path(@task)
    else
      set_selected_users
      render "edit"
    end
  end

  def mark_completed
    @task.update(task_params)

    respond_to do |format|
      format.html do
        flash[:notice] = "Your task has been marked as completed"
        redirect_to :back
      end
      format.js
    end

  end

  def update_assignees
    if params[:group_id].empty?
      @selected_users = [current_user]
    else
      group = Group.find(params[:group_id])
      @selected_users = group.users.order(:username)
      @selected = current_user.id
    end
  end

  def personal
    @tasks = @tasks.select { |task| task.creator == current_user and task.group.nil? }
    set_outstanding_and_completed_tasks
    @show_assignee = false
    @title = "#{current_user.username}'s personal list"
    render "index"
  end

  def assigned
    @tasks = @tasks.select { |task| task.assignee == current_user }
    set_outstanding_and_completed_tasks
    @show_assignee = false
    @title = "Tasks assigned to #{current_user.username}"
    render "index"
  end

  private

  def task_params
    params.require(:task).permit(:title, :note, :due_date, :priority, :assigned_to, :completed, :group_id)
  end

  def set_task
    @task = Task.find_by(slug: params[:id])
  end

  def set_tasks
    @tasks = Task.all.order(:due_date).select do |task|
      if task.group.nil?
        task.creator == current_user
      else
        task.group.users.include?(current_user)
      end
    end
  end

  def set_selected_users
    if @task.group_id.nil?
      @selected_users = [current_user]
    else
      group = Group.find(@task.group_id)
      @selected_users = group.users.order(:username)
    end
  end

  def require_creator_or_assignee
    access_denied unless logged_in? and (current_user == @task.creator or current_user == @task.assignee)
  end

  def require_creator_or_group_member
    if @task.group.nil?
      access_denied unless logged_in? and current_user == @task.creator
    else
      access_denied unless logged_in? and @task.group.users.include?(current_user)
    end
  end
end