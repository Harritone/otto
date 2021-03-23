class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def new
    @customer = Customer.new
    @order = Order.new
    @order.order_products.build
  end

  def create
    @order = Order.new(order_params)
    if params[:customer][:id].present?
      customer = Customer.find(params[:customer][:id])
      if customer.first_name != params[:customer][:first_name] || 
         customer.last_name != params[:customer][:last_name] || 
         customer.zipcode != params[:customer][:zipcode]
        @order.errors[:customer] << "Customer info is incorrect"
        render :new and return
      end
    else
      customer = Customer.create(customer_params)
    end
    
    unless customer.valid?
      @order.errors[:customer] << "Customer info is incorrect"
      render :new and return
    end
    
    @order.customer_id = customer.id
    
    if @order.save
      unless @order.has_products?
        @order.errors[:products] << "You should add at least one product"
        @order.destroy
        render :new and return
      end
      redirect_to @order, notice: "Order was successfully created." 
    else
      render :new, notice: "Something went wrong"
    end
  end

   def destroy
    @order = Order.find(params[:id])
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

   def customer_params
    params.require(:customer).permit(:id, :first_name, :last_name, :zipcode)
   end

end