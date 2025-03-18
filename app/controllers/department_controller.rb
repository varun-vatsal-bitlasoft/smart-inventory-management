class DepartmentController < ApplicationController

  layout "home_layout"

  before_action :authenticate_user?
  before_action :user_permission?, only: [:create, :show]

  def show
    @departments = Department.all
  end

  def create
    @department = Department.new
    if request.post?
      @department = Department.new(department_params)
      if @department.save
        redirect_to :controller => :department, :action => :show, notice: "Department created successfully!"
      else
        render :create, status: :unprocessable_entity
      end
    end
  end

  private

  def authenticate_user?
    if session[:user_id].nil?
      flash[:notice] = "you need to login as a admin to continue"
      redirect_to :controller => :users, :action => :login
    end
  end

  def user_permission?
 
    role_description_id = User.find_by(id: session[:user_id]).role_description_id

    privilege = JSON.parse(RoleDescription.find(role_description_id).privilege)

    if !privilege['department'].has_key?('all')
      redirect_to :controller => :users, :action => :dashboard, notice: "you dont have permission to modify department"
    end
    
  end 

  def department_params
    params.require(:department).permit(:name, :description)
  end
end
