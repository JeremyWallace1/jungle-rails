class Admin::DashboardController < Admin::BaseController
  def show
    @category = Category.all.order(created_at: :desc)
    @products = Product.all.order(created_at: :desc)
    @orders = Order.all.order(created_at: :desc)
  end
end
