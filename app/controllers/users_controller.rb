# require 'json'

class UsersController < ApplicationController

  layout :choose_layout
  before_action :authenticate_user?, only: [:dashboard, :show]
  before_action :user_permission?, only: [:create, :delete, :show, :update]

  def login 
    if request.post?
      user = User.find_by(username: params[:username])
      if user.nil?
        flash[:alert] = "user does not exists"
        redirect_to :controller => :users, :action => :login
      end

      if user&.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to :controller => :users, :action => :dashboard, notice: "Logged in successfully!"
      else 
        flash[:alert] = "invalid username or password"
        redirect_to :controller => :users, :action => :login  
      end

    end
  end

  def logout
    session[:user_id] = nil
    flash[:alert] = "Logged out!"
    redirect_to :controller => :users, :action => :login
  end

  def dashboard
    if is_admin?
      @total_product_transaction = ProductTransaction.group_by_day(:transaction_date).sum(:size)

      @total_inventory_expiry = Inventory.group_by_day(:expiry).sum(:size)

      @price_per_product = Product.group(:name).sum(:price)
        

      @department_total_products_price = Department.joins(:products)
                                        .group("departments.name")
                                        .sum("products.price")
                                        
      @total_size_products = Product.joins(:inventories)
                                    .group("products.name")
                                    .sum("inventories.size")

    else 

      @total_product_transaction = ProductTransaction.joins(:product)
                                  .where(products: { department_id: User.find(session["user_id"]).department_id })
                                  .group_by_day(:transaction_date).sum(:size) 

      @total_inventory_expiry = Inventory.joins(:product)
                                .where(products: { department_id: User.find(session["user_id"]).department_id })
                                .group_by_day(:expiry).sum(:size)

      @price_per_product = Product.where(department_id: User.find(session["user_id"]).department_id)
                                  .group(:name).sum(:price)

      @total_size_products =  Inventory.joins(:product)
                                       .where(products: { department_id: User.find(session["user_id"]).department_id })
                                       .group("products.name")
                                       .sum(:size)

      
    end
  end

  def create 
    @departments = Department.all 
    @roles = RoleDescription.all
    @user = User.new
    if request.post?
      user = User.new(user_params)
      if user.save 
        NotificationMailer.welcome_email(user).deliver_now
        redirect_to :controller => :users, :action => :show, notice: "user created"
      else
        Rails.logger.error user.errors
        redirect_to :controller => :users, :action => :create, notice: "pass a valid user"
      end
    end
  end

  def edit 
    @user = User.find_by(id: params[:id])
    @departments = Department.all 
    @roles = RoleDescription.all
  end

  def update
    @user = User.find_by(id: params[:id])
    if request.post?
      res = @user.update(user_params)

      if res 
        redirect_to :controller => :users, :action => :show, notice: "user created"
      else
        redirect_to :controller => :users, :action => :update, notice: "pass a valid user"
      end
    end
  end

  def delete 
    id = params[:id]
    user = User.find_by(id: id)
    user.delete
    redirect_to :controller => :users, :action => :show
  end

  def show
    @users = User.all
  end

  private 

  def choose_layout
    case action_name
    when "dashboard", "show", "create", "edit"
      "home_layout"
    when "login"
      "authentication_layout"
    end
  end

  def authenticate_user?
    if session[:user_id].nil?
      flash[:notice] = "you need to login as a admin to continue"
      redirect_to :controller => :users, :action => :login
    end
  end

  def user_permission?
    authenticate_user?
    role_description_id = User.find_by(id: session[:user_id]).role_description_id

    privilege = JSON.parse(RoleDescription.find(role_description_id).privilege)

    if !privilege['department'].has_key?('all')
      redirect_to :controller => :users, :action => :dashboard, notice: "you dont have permission to modify users"
    end
    
  end 

  def is_admin?
    RoleDescription.find(User.find(session[:user_id]).role_description_id).name == "admin"
  end

  def user_params
    params.require(:user).permit(:username, :email, :mobile, :password, :password_confirmation, :department_id, :role_description_id)
  end

end

