class Admin::SalesController < Admin::BaseController
  def index
    @sales = Sale.all
  end
end
