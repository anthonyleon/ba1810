class ChargesController < ApplicationController
  protect_from_forgery with: :null_session

  def new
  end

  def index
  end

  def create

    # Amount in cents
    @amount = 500
    Stripe.api_key = 'secret test key'
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
