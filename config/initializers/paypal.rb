# Configuration PayPal
Rails.configuration.paypal = {
  client_id: ENV['PAYPAL_CLIENT_ID'],
  client_secret: ENV['PAYPAL_CLIENT_SECRET'],
  mode: ENV['PAYPAL_MODE'] || 'sandbox' # 'sandbox' ou 'live'
}

# URLs de base PayPal selon le mode
Rails.configuration.paypal[:base_url] = if Rails.configuration.paypal[:mode] == 'live'
  'https://api.paypal.com'
else
  'https://api.sandbox.paypal.com'
end

# Configurer PayPal uniquement si les clés sont présentes
if Rails.configuration.paypal[:client_id].present? && Rails.configuration.paypal[:client_secret].present?
  Rails.logger.info "✅ PayPal configuré en mode #{Rails.configuration.paypal[:mode]}"
else
  Rails.logger.warn "⚠️ PayPal n'est pas configuré. Les paiements PayPal ne fonctionneront pas."
end

