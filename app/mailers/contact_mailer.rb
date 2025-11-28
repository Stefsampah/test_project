class ContactMailer < ApplicationMailer
  # Envoyer un message de contact à contact@tubenplay.com
  def contact_message(name, email, subject, message)
    @name = name
    @email = email
    @subject = subject || "Message depuis le formulaire de contact"
    @message = message

    mail(
      to: 'contact@tubenplay.com',
      subject: "[Tube'NPlay Contact] #{@subject}",
      reply_to: email # Permet de répondre directement à l'utilisateur
    )
  end
end

