# Configuration Stripe
Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
  secret_key: ENV['STRIPE_SECRET_KEY']
}

# Configurer l'API Stripe uniquement si la clé est présente
if Rails.configuration.stripe[:secret_key].present?
  Stripe.api_key = Rails.configuration.stripe[:secret_key]
else
  Rails.logger.warn "⚠️ STRIPE_SECRET_KEY n'est pas configurée. Les paiements Stripe ne fonctionneront pas."
end
