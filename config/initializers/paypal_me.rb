# Configuration PayPal.me
Rails.configuration.paypal_me = {
  link: ENV['PAYPAL_ME_LINK'] || '',
  enabled: ENV['PAYPAL_ME_ENABLED'] == 'true' || false
}

if Rails.configuration.paypal_me[:enabled] && Rails.configuration.paypal_me[:link].present?
  Rails.logger.info "✅ PayPal.me configuré : #{Rails.configuration.paypal_me[:link]}"
else
  Rails.logger.warn "⚠️ PayPal.me n'est pas configuré. Les paiements PayPal.me ne fonctionneront pas."
end

