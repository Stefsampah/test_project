class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @user = current_user
    @vip_active = current_user.vip_subscription && current_user.vip_expires_at && current_user.vip_expires_at > Time.current
    @expires_at = current_user.vip_expires_at
    @days_remaining = @expires_at ? (@expires_at - Time.current).to_i / 1.day : 0
  end
  
  def checkout
    # Charger la page de paiement PayPal pour le renouvellement VIP
    begin
      if paypal_configured?
        # Mode réel - utiliser PayPal
        result = ::PayPalService.create_payment(
          amount: 9.99,
          currency: 'EUR',
          description: "Renouvellement VIP - Accès premium pour #{current_user.email}",
          return_url: subscriptions_renewed_url + "?success=true",
          cancel_url: subscriptions_index_url,
          metadata: {
            user_id: current_user.id,
            subscription_type: 'vip_renewal'
          }
        )
        
        if result[:success]
          # Stocker le payment_id en session pour la vérification
          session[:paypal_payment_id] = result[:payment_id]
          session[:paypal_subscription_type] = 'vip_renewal'
          
          redirect_to result[:approval_url], allow_other_host: true
        else
          Rails.logger.error "Erreur création paiement PayPal: #{result[:error]}"
          redirect_to subscriptions_index_path, alert: "❌ Erreur lors du traitement. Veuillez réessayer."
        end
      elsif current_user.admin?
        # Mode simulation réservé aux administrateurs
        current_user.update!(vip_subscription: true, vip_expires_at: 1.month.from_now)
        
        Rails.logger.info "Simulation de renouvellement VIP (admin): User #{current_user.id} a renouvelé son abonnement VIP pour 9.99€"
        
        redirect_to subscriptions_index_path, notice: "🎉 Abonnement VIP renouvelé avec succès ! (Mode administrateur)"
      else
        Rails.logger.error "PayPal non configuré pour le renouvellement VIP"
        redirect_to subscriptions_index_path, alert: t('store.messages.paypal_not_configured')
      end
    rescue => e
      Rails.logger.error "Erreur PayPal: #{e.message}"
      redirect_to subscriptions_index_path, alert: "❌ Erreur lors du traitement. Veuillez réessayer."
    end
  end
  
  def renewed
    # Traiter le renouvellement après paiement PayPal
    payment_id = params[:paymentId] || session[:paypal_payment_id]
    payer_id = params[:PayerID]
    success = params[:success]
    
    if success == 'true' && payment_id.present? && payer_id.present?
      # Exécuter le paiement PayPal
      begin
        result = ::PayPalService.execute_payment(payment_id: payment_id, payer_id: payer_id)
        
        if result[:success]
          # Renouveler l'abonnement
          current_user.update!(
            vip_subscription: true,
            vip_expires_at: 1.month.from_now
          )
          
          # Nettoyer la session
          session.delete(:paypal_payment_id)
          session.delete(:paypal_subscription_type)
          
          Rails.logger.info "Abonnement VIP renouvelé: User #{current_user.id}"
          redirect_to subscriptions_index_path, notice: "🎉 Abonnement VIP renouvelé avec succès ! Accès prolongé jusqu'au #{current_user.vip_expires_at.strftime('%d/%m/%Y')}"
        else
          Rails.logger.error "Erreur exécution paiement PayPal: #{result[:error]}"
          redirect_to subscriptions_index_path, alert: "❌ Erreur lors du traitement du paiement. Veuillez réessayer."
        end
      rescue => e
        Rails.logger.error "Erreur lors du traitement du paiement: #{e.message}"
        redirect_to subscriptions_index_path, alert: "❌ Erreur lors du traitement du paiement. Veuillez réessayer."
      end
    elsif success == 'true' && current_user.admin?
      # Mode simulation réservé aux administrateurs
      current_user.update!(
        vip_subscription: true,
        vip_expires_at: 1.month.from_now
      )
      
      Rails.logger.info "Abonnement VIP renouvelé (mode administrateur): User #{current_user.id}"
      redirect_to subscriptions_index_path, notice: "🎉 Abonnement VIP renouvelé avec succès ! (Mode administrateur)"
    else
      redirect_to subscriptions_index_path, alert: "❌ Problème lors du renouvellement"
    end
  end
  
  def status
    # API endpoint pour vérifier le statut VIP
    user = User.find(params[:user_id])
    vip_active = user.vip_subscription && user.vip_expires_at && user.vip_expires_at > Time.current
    
    render json: {
      vip_active: vip_active,
      expires_at: user.vip_expires_at&.iso8601,
      days_remaining: vip_active ? ((user.vip_expires_at - Time.current) / 1.day).ceil : 0
    }
  end
  
  private

  def paypal_configured?
    Rails.configuration.paypal[:client_id].present? && Rails.configuration.paypal[:client_secret].present?
  end
end
