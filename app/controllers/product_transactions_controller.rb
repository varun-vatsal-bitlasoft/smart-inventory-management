class ProductTransactionsController < ApplicationController

  layout "home_layout"

  before_action :authenticate_user?

  def show
    if is_admin?
      @product_transactions = ProductTransaction.all
    else
      @product_transactions = Department.find(User.find(session[:user_id]).department_id)
                              .products
                              .includes(:product_transactions)
                              .flat_map(&:product_transactions)

      Rails.logger.info @product_transactions
    end
  end

  def create_form
    @id = params[:id]
    @product_transactions = ProductTransaction.new
  end

  def create
    @id = params[:id]
    size = Inventory.find(@id).size.to_i
    @product_id = Inventory.find(@id).product_id

    if params[:product_transaction][:in_going] == "0"
      if params[:product_transaction][:size].to_i > size 
        flash[:notice] = "size should be less that or equal to inventory size"
        redirect_to :controller => :product_transactions, :action => :create_form
        return 
      end
    end

    @product_transactions = ProductTransaction.new(size: params[:product_transaction][:size], transaction_date: params[:product_transaction][:transaction_date], price: params[:product_transaction][:price], in_going: params[:product_transaction][:in_going] == "1" ? true : false, product_id: @product_id, inventory_id: @id)

    @product_transactions.valid?

    Rails.logger.error @product_transactions.errors.full_messages

    if @product_transactions.save
      inven = Inventory.find(@id)
      if params[:product_transaction][:in_going] == "1"
        inven.update(size: size + params[:product_transaction][:size].to_i)
      else
        inven.update(size: size - params[:product_transaction][:size].to_i)
      end
      flash[:notice] = "product_transactions successfully created!"
      redirect_to :controller => :product_transactions, :action => :show
      return 
    else
      flash[:notice] = "Error creating inventory."
      redirect_to :controller => :inventories, :action => :show
      return 
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
