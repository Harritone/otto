class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
    # to add fields we build order_product
    @order.order_products.build
  end

  def create
    # creates new object from permitted params
    @order = Order.new(order_params)
    # check if order has products
    unless @order.has_products?
      @order.errors[:products] << "You should add at least one product"
      render :new and return
    end
    # check if we have customer id in params
    if params[:customer][:id].present?
      # and if we have - check if the record exists
      if Customer.exists?(params[:customer][:id]) 
        # if exists assign to the variable
        customer = Customer.find(params[:customer][:id]) 
        # else - add error to order and render new
      else
        @order.errors[:customer] << "Customer info is incorrect"
        render :new and return
      end
      # check customer's attributes with attributes we get from params
      if customer.first_name != params[:customer][:first_name] || 
         customer.last_name != params[:customer][:last_name] || 
         customer.zipcode != params[:customer][:zipcode] 
        @order.errors[:customer] << "Customer info is incorrect"
        render :new and return
      end
      # if params don't contain customer id create new customer
    else
      customer = Customer.create(customer_params)
    end
    
    # check if customer object is valid
    unless customer.valid?
      # if not valid add error to :customer and return
      @order.errors[:customer] << "Customer info is incorrect"
      render :new and return
    end
    
    # add customer_id to order
    @order.customer_id = customer.id
    
    if @order.save
      redirect_to root_path, notice: "Order was successfully created." 
    else
      render :new, notice: "Something went wrong"
    end
  end

   def destroy
    @order = Order.find(params[:id])
    @order.destroy
      redirect_to root_path, notice: "Order was successfully destroyed."
  end

  private

   def order_params
     params.require(:order).permit({}, order_products_attributes: [:id, :product_id, :order_id, :quantity, :_destroy])
   end

   def customer_params
    params.require(:customer).permit(:id, :first_name, :last_name, :zipcode)
   end

end