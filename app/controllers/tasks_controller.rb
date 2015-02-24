class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :mark_completed]
  before_action :require_user
  before_action :require_creator_or_assignee, only: [:edit, :update, :mark_completed]

  def index
    @tasks = Task.all
    @title = "All tasks"
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.creator = current_user

    if @task.save
      flash[:notice] = "Your task has been created"
      redirect_to tasks_path
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:notice] = "Your task has been updated"
      redirect_to task_path(@task)
    else
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

  def created
    @tasks = Task.all.select { |task| task.created_by == current_user.id }
    @title = "Tasks created by #{current_user.username}"
    render "index"
  end

  def assigned
    @tasks = Task.all.select { |task| task.assigned_to == current_user.id }
    @title = "Tasks assigned to #{current_user.username}"
    render "index"
  end

  def completed
    @tasks = Task.all.select { |task| task.completed }
    @title = "All completed tasks"
    render "index"
  end

  def outstanding
    @tasks = Task.all.select { |task| !task.completed }
    @title = "All outstanding tasks"
    render "index"
  end

  private

  def task_params
    params.require(:task).permit(:title, :note, :due_date, :priority, :assigned_to, :completed)
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def require_creator_or_assignee
    access_denied unless logged_in? and (current_user == @task.creator or current_user == @task.assignee)
  end
end