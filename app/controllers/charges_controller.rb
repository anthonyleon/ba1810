class ChargesController < ApplicationController
  def new
  end

  def index
  end

  def create

    # Amount in cents
    @amount = 500
    Stripe.api_key = 'sk_test_JaFXqkUnZAlFA2jNazzMGtlg'
    token = params[:stripeToken]
    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'usd',
      :source => token
    )
    
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to company_path(current_user)
  end
end
