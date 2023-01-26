class Admin::DashboardController < ApplicationController
  def show
    @category = Category.all.order(created_at: :desc)
    @products = Product.all.order(created_at: :desc)
  end
end
