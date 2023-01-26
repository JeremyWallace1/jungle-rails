class Admin::OrdersController < ApplicationController
  http_basic_authenticate_with name: ENV["ADMIN_USER_NAME"], password: ENV["ADMIN_PASSWORD"]
  
  def index
    @orders = Order.order(id: :asc).all
  end

end