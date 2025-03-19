class ProductsController < ApplicationController

  layout "home_layout"

  before_action :authenticate_user?

  def show
    if is_admin? 
      @products = Product.all
    else
      @products = Department.find(User.find(session[:user_id]).department_id).products
    end
  end

  def create_form
    if is_admin? 
      @department = Department.all
    else 
      @department = Department.find(User.find(session[:user_id]).department_id)
    end
    @product = Product.new

  end

  def create
    @product = Product.new(product_params)

    if @product.save
      flash[:notice] = "Product successfully created!"
      redirect_to :controller => :products, :action => :show
    else
      flash[:alert] = "Error creating product."
      render :new, status: :unprocessable_entity
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

  def product_params
    params.require(:product).permit(:name, :description, :price, :department_id)
  end

end
