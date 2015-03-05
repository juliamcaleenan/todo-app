class GroupsController < ApplicationController
  before_action :require_user
  before_action :set_group, only: [:show, :edit, :update]
  before_action :require_creator, only: [:edit, :update]
  before_action :require_member, only: [:show]

  def index
    @groups = current_user.groups
  end

  def show
    @tasks = @group.tasks.order(:due_date)
    set_outstanding_and_completed_tasks
    @show_assignee = true
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.creator = current_user
    @group.users << current_user

    if @group.save
      flash[:notice] = "Your group has been created"
      redirect_to group_path(@group)
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      flash[:notice] = "The group details have been updated"
      redirect_to group_path(@group)
    else
      render "edit"
    end
  end

  def join_new
  end

  def join_create
    group = Group.find_by(name: params[:name])

    if group && group.authenticate(params[:password])
      if group.users.include?(current_user)
        flash[:error] = "You are already a member of #{group.name}"
        redirect_to group_path(group)
      else
        group.users << current_user
        flash[:notice] = "You are now a member of #{group.name}"
        redirect_to group_path(group)
      end
    else
      flash[:error] = "The group details have not been recognised"
      render "join_new"
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :password, :created_by)
  end 

  def set_group
    @group = Group.find_by(slug: params[:id])
  end

  def require_creator
    access_denied unless logged_in? and @group.creator == current_user
  end

  def require_member
    access_denied unless logged_in? and @group.users.include?(current_user)
  end
end