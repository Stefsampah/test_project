class ContactController < ApplicationController
  def index
    # Page de contact - accessible à tous
    # URL de la photo de contact (à mettre sur Cloudinary)
    @contact_photo_url = ENV['CONTACT_PHOTO_URL'] || nil
  end

  def send_message
    name = params[:name]
    email = params[:email]
    subject = params[:subject]
    message = params[:message]

    # Validation
    if name.blank? || email.blank? || message.blank?
      redirect_to contact_path, alert: "Veuillez remplir tous les champs obligatoires."
      return
    end

    # Validation email
    unless email.match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
      redirect_to contact_path, alert: "L'adresse email n'est pas valide."
      return
    end

    begin
      # Envoyer l'email via ContactMailer
      ContactMailer.contact_message(name, email, subject, message).deliver_now
      
      Rails.logger.info "Message de contact envoyé - De: #{email}, Sujet: #{subject}"
      
      redirect_to contact_path, notice: "✅ Votre message a été envoyé avec succès ! Je vous répondrai dans les plus brefs délais."
    rescue => e
      Rails.logger.error "Erreur lors de l'envoi du message de contact: #{e.message}"
      redirect_to contact_path, alert: "❌ Une erreur est survenue lors de l'envoi du message. Veuillez réessayer plus tard."
    end
  end
end

