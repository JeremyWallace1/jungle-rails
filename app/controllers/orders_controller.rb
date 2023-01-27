class OrdersController < ApplicationController

  def show
    @order = Order.find(params[:id])
    @current_sale ||= Sale.active[0]
  end
  helper_method :current_sale

  def create
    charge = perform_stripe_charge
    order  = create_order(charge)

    if order.valid?
      empty_cart!
      redirect_to order, notice: 'Your Order has been placed.'
    else
      redirect_to cart_path, flash: { error: order.errors.full_messages.first }
    end

  rescue Stripe::CardError => e
    redirect_to cart_path, flash: { error: e.message }
  end

  private

  def empty_cart!
    # empty hash means no products in cart :)
    update_cart({})
  end

  def perform_stripe_charge
    if current_sale
      charge_amount = (cart_subtotal_cents * (1 - (current_sale.percent_off.to_f / 100.0))).to_i
    else
      charge_amount = cart_subtotal_cents
    end
    Stripe::Charge.create(
      source:      params[:stripeToken],
      amount:      charge_amount,
      description: "Khurram Virani's Jungle Order",
      currency:    'cad'
    )
  end

  def create_order(stripe_charge)
    if current_sale
      charge_amount = (cart_subtotal_cents * (1 - (current_sale.percent_off.to_f / 100.0))).to_i
    else
      charge_amount = cart_subtotal_cents
    end
    order = Order.new(
      email: params[:stripeEmail],
      total_cents: charge_amount,
      stripe_charge_id: stripe_charge.id, # returned by stripe
    )

    enhanced_cart.each do |entry|
      product = entry[:product]
      quantity = entry[:quantity]
      order.line_items.new(
        product: product,
        quantity: quantity,
        item_price: product.price,
        total_price: product.price * quantity
      )
    end
    order.save!
    order
  end

end
