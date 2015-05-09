class ProjectsController < ApplicationController
  before_filter :authenticate_user!, except: [:show,:index]
  def index
    @projects = Project.all
  end

  def show
    @project = Project.find params[:id]
  end

  def new
    @project=Project.new
    @links = [Link.new]
    render action: 'edit'
  end

  def create
    @project = Project.new params[:project].permit!
    if @project.save
      permission = Permission.new
      permission.project_id = @project.id
      permission.user_id = current_user.id
      permission.level = "owner"
      if permission.save
        redirect_to @project
      else
        @project.destroy
        flash[:error] ="Unknown error"
        redirect_to edit_project_path
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @project = Project.find params[:id]
    @links = @project.links
  end

  def update
    @project = Project.find params[:id]
    if current_user.level_in(@project).to_i > 1
      flash[:error]="You do not have the required permissions for that action"
      redirect_to request.referrer
    end
    @project.update_attributes params[:project].permit!
    if @project.save
      flash[:success]="Successfully updated project \"#{@project.title}\""
    else
      flash[:error] = "Error updating #{@project.title}, #{@project.errors.messages.to_s}"
    end
    redirect_to @project
  end

  def destroy
    @project = Project.find params[:id]
    if current_user.level_in(@project).to_i > 0
      flash[:error]="You do not have the required permissions for that action"
      redirect_to request.referrer
    else
      if @project.destroy
        flash[:success]= "Successfully deleted project \"#{@project.title}\""
        redirect_to root_path
      else
        flash[:danger] = "Error"
      end
    end
  end

  def contrib
    @project= Project.find params[:id]
    p=Permission.where(user_id:current_user.id,project_id:@project.id)
    if p.count == 0
      p=Permission.new(user_id:current_user.id,project_id:@project.id,level:"contributor")
      p.save
    else
      if p.first.level.to_i > 2
        p.level.to_i = 2
      end
    end
    flash[:success] = "You are now listed as a contributor to #{@project.title}"
    redirect_to @project
  end

  def uncontrib
    @project= Project.find params[:id]
    p=Permission.where(user_id:current_user.id,project_id:@project.id)
    if p.count == 0
      redirect_to @project
    elsif p.first.level == "owner"
      flash[:error] = "You are the owner of this project, you must delete the project"
      redirect_to @project
    else
      p.first.destroy
      flash[:success] = "You have successfully removed yourself as a contributor"
      redirect_to @project
    end
  end
end

def project_filter
  if defined? params[:id]
    @project = Project.find params[:id]
  end
end