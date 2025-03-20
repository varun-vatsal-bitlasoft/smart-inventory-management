class RoleDescriptionController < ApplicationController

  layout "home_layout"

  before_action :authenticate_user?
  before_action :user_permission?, only: [:create, :show]

  def show
    @role_descriptions = RoleDescription.all
  end

  def create
    @role_description = RoleDescription.new
    @departments = Department.all

    if request.post?
      
      privileges = {}
      
      params[:permissions]&.each do |department_id, actions|
        privileges[Department.find(department_id).name] = {
          create: actions.key?("create") ? 1 : 0,
          read: actions.key?("read") ? 1 : 0,
          update: actions.key?("update") ? 1 : 0,
          delete: actions.key?("delete") ? 1 : 0
        }
      end

      final = {department: privileges}

      @role = RoleDescription.new(name: params[:role_description][:name], privilege: final.to_json)

      if @role.save
        flash[:notice] = "Role successfully created!"
        redirect_to :controller => :role_description, :action => :show
      else
        flash[:alert] = "Error creating role."
        redirect_to :controller => :role_description, :action => :create, alert: "pass valid role"
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

end
