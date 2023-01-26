class Admin::DashboardController < ApplicationController
  http_basic_authenticate_with name: ENV["ADMIN_USER_NAME"], password: ENV["ADMIN_PASSWORD"]
  def show
    @category = Category.all.order(created_at: :desc)
    @products = Product.all.order(created_at: :desc)
  end
end
