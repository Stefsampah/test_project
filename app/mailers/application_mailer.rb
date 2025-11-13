class ApplicationMailer < ActionMailer::Base
  # Configuration de l'expéditeur par défaut
  # Priorité: 1. Variable d'environnement, 2. Credentials Rails, 3. Valeur par défaut
  default from: default_from_address
  layout "mailer"

  private

  def self.default_from_address
    ENV.fetch('MAILER_FROM_ADDRESS') do
      Rails.application.credentials.dig(:mailer, :from_address) || "noreply@#{ENV.fetch('MAILER_DOMAIN', 'example.com')}"
    end
  end
end
