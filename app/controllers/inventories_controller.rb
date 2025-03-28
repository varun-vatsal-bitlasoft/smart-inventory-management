class InventoriesController < ApplicationController

  layout "home_layout"

  before_action :authenticate_user?

  def show
    if is_admin?
      @inventories = Inventory.all
    else
      @inventories = Department.find(User.find(session[:user_id]).department_id)
                        .products
                        .includes(:inventories)
                        .flat_map(&:inventories)

      Rails.logger.info @inventories
    end
  end

  def create_form
    @id = params[:id]
    @inventory = Inventory.new 
  end

  def create
    @inventory = Inventory.new(size: params[:inventory][:size], expiry: params[:inventory][:expiry], price: params[:inventory][:price], product_id: params[:id])

    @inventory.valid?

    if params[:inventory][:expiry].to_date < Time.now.to_date
      flash[:notice] = "expiry date should not be less than current date"
      redirect_to :controller => :inventories, :action => :create_form
      return
    end

    Rails.logger.error @inventory.errors.full_messages

    if @inventory.save
      flash[:notice] = "Inventory successfully created!"
      redirect_to :controller => :inventories, :action => :show
    else
      flash[:notice] = "Error creating inventory."
      redirect_to :controller => :products, :action => :show
    end
  end

  private

  def authenticate_user?
    if session[:user_id].nil?
      flash[:notice] = "you need to login as a admin to continue"
      redirect_to :controller => :users, :action => :login
    end
  end

  def is_admin?
    RoleDescription.find(User.find(session[:user_id]).role_description_id).name == "admin"
  end
end
