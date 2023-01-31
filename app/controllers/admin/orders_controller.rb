class Admin::OrdersController < Admin::BaseController
 
  def index
    @orders = Order.order(id: :asc).all
  end

end