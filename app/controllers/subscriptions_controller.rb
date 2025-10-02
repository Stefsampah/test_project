class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @user = current_user
    @vip_active = current_user.vip_subscription && current_user.vip_expires_at && current_user.vip_expires_at > Time.current
    @expires_at = current_user.vip_expires_at
    @days_remaining = @expires_at ? (@expires_at - Time.current).to_i / 1.day : 0
  end
  
  def checkout
    # Charger la page de paiement Stripe pour le renouvellement VIP
    begin
      session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: [ {
            price_data: {
              currency: 'eur',
              product_data: {
                name: "Renouvellement VIP",
                description: "Renouvellement accès premium pour #{current_user.email}"
              },
              unit_amount: 999, # 9.99€ en centimes
            },
            quantity: 1,
          }],
        mode: 'payment',
        success_url: subscriptions_renewed_url + "?success=true",
        cancel_url: subscriptions_index_url,
        customer_email: current_user.email,
        metadata: {
          user_id: current_user.id,
          subscription_type: 'vip_renewal'
        }
      })
      
      redirect_to session.url, allow_other_host: true
    rescue Stripe::CardError => e
      redirect_to subscriptions_index_path, alert: "❌ Erreur de carte: #{e.message}"
    rescue => e
      Rails.logger.error "Erreur Stripe: #{e.message}"
      redirect_to subscriptions_index_path, alert: "❌ Erreur lors du traitement. Veuillez réessayer."
    end
  end
  
  def renewed
    # Traiter le renouvellement après paiement Stripe
    session_id = params[:session_id]
    success = params[:success]
    
    if success == 'true'
      # Renouveler l'abonnement
      current_user.update!(
        vip_subscription: true,
        vip_expires_at: 1.month.from_now
      )
      
      Rails.logger.info "Abonnement VIP renouvelé: User #{current_user.id}"
      redirect_to subscriptions_index_path, notice: "🎉 Abonnement VIP renouvelé avec succès ! Accès prolongé jusqu'au #{current_user.vip_expires_at.strftime('%d/%m/%Y')}"
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
end
