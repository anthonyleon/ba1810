Rails.configuration.stripe = {
  :publishable_key => ENV['GHSQ1SVwsKr7xQcMKMbYGh7h'],
  :secret_key      => ENV['JaFXqkUnZAlFA2jNazzMGtlg']
}

Stripe.api_key = Rails.configuration.stripe[:publishable_key]
