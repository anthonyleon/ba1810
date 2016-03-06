require "stripe"
Stripe.api_key = "sk_test_JaFXqkUnZAlFA2jNazzMGtlg"


Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
