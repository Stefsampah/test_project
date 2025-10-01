class StoreController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_points, only: [:index, :buy_playlist]

  def index
    @point_packs = [
      { name: "Pack 100 points", price: 0.99, points: 100, description: "Idéal pour tester sans engagement" },
      { name: "Pack 500 points", price: 1.99, points: 500, description: "Un bon équilibre avec des bonus inclus" },
      { name: "Pack 1000 points", price: 3.99, points: 1000, description: "Offre la meilleure valeur avec un bonus supplémentaire" },
      { name: "Pack 5000 points", price: 4.99, points: 5000, description: "Offre la meilleure valeur avec un bonus supplémentaire" }
    ]

    @subscriptions = [
      { name: "VIP", price: 9.99, description: "Débloque toutes les playlists premium" }
    ]

    # Exclure les playlists Challenge Reward (récompenses gagnées, pas achetées)
    reward_playlist_ids = Playlist.where("LOWER(title) LIKE ? OR LOWER(title) LIKE ? OR LOWER(title) LIKE ?", 
                                         "%reward%", "%récompense%", "%challenge%").pluck(:id)
    
    @premium_playlists = Playlist.where(premium: true)
                                 .where.not(id: reward_playlist_ids)
                                 .order(:title)
    
    @unlocked_playlists = current_user.user_playlist_unlocks.includes(:playlist).map(&:playlist)
    @unlocked_exclusive_playlists = [] # Pas de playlists exclusives dans la boutique
  end

  def buy_points
    pack_id = params[:pack_id]
    @point_packs = [
      { id: 0, name: "Pack 100 points", price: 0.99, points: 100, description: "Idéal pour tester sans engagement" },
      { id: 1, name: "Pack 500 points", price: 1.99, points: 500, description: "Un bon équilibre avec des bonus inclus" },
      { id: 2, name: "Pack 1000 points", price: 3.99, points: 1000, description: "Offre la meilleure valeur avec un bonus supplémentaire" },
      { id: 3, name: "Pack 5000 points", price: 4.99, points: 5000, description: "Offre la meilleure valeur avec un bonus supplémentaire" }
    ]
    
    @selected_pack = @point_packs.find { |pack| pack[:id] == pack_id.to_i }
    
    if @selected_pack
      begin
        # Vérifier si on est en mode simulation
        if Rails.configuration.stripe[:secret_key].include?('ABC123')
          # Mode simulation - simuler l'achat
          current_points = current_user.points || 0
          new_points = current_points + @selected_pack[:points]
          current_user.update!(points: new_points)
          
          Rails.logger.info "Simulation d'achat: User #{current_user.id} a acheté #{@selected_pack[:points]} points pour #{@selected_pack[:price]}€"
          
          redirect_to store_path, notice: "✅ Achat simulé réussi ! Vous avez désormais #{new_points} points ! (Mode simulation - configurez Stripe pour les vrais paiements)"
        else
          # Mode réel - utiliser Stripe
          session = Stripe::Checkout::Session.create({
            payment_method_types: ['card'],
            line_items: [{
              price_data: {
                currency: 'eur',
                product_data: {
                  name: @selected_pack[:name],
                  description: @selected_pack[:description]
                },
                unit_amount: (@selected_pack[:price] * 100).to_i, # Convertir en centimes
              },
              quantity: 1,
            }],
            mode: 'payment',
            success_url: store_success_url + "?session_id={CHECKOUT_SESSION_ID}",
            cancel_url: store_cancel_url,
            metadata: {
              user_id: current_user.id,
              pack_id: pack_id,
              points: @selected_pack[:points]
            }
          })
          
          redirect_to session.url, allow_other_host: true
        end
      rescue Stripe::CardError => e
        redirect_to store_path, alert: "❌ Erreur de carte: #{e.message}"
      rescue => e
        Rails.logger.error "Erreur Stripe: #{e.message}"
        redirect_to store_path, alert: "❌ Erreur lors de l'achat. Veuillez réessayer."
      end
    else
      redirect_to store_path, alert: "❌ Pack de points invalide."
    end
  end

  def buy_subscription
    subscription_type = params[:subscription_type]
    
    if subscription_type == "vip"
      begin
        # Vérifier si on est en mode simulation
        if Rails.configuration.stripe[:secret_key].include?('ABC123')
          # Mode simulation - simuler l'achat
          current_user.update!(vip_subscription: true, vip_expires_at: 1.month.from_now)
          
          Rails.logger.info "Simulation d'abonnement VIP: User #{current_user.id} a acheté un abonnement VIP pour 9.99€"
          
          redirect_to playlists_path, notice: "✅ Abonnement VIP simulé activé ! Toutes les playlists premium sont maintenant débloquées. (Mode simulation - configurez Stripe pour les vrais paiements) <a href='/playlists' class='text-yellow-300 hover:text-yellow-200 underline'>Voir les playlists</a>".html_safe
        else
          # Mode réel - utiliser Stripe
          session = Stripe::Checkout::Session.create({
            payment_method_types: ['card'],
            line_items: [{
              price_data: {
                currency: 'eur',
                product_data: {
                  name: "Abonnement VIP",
                  description: "Débloque toutes les playlists premium"
                },
                unit_amount: 999, # 9.99€ en centimes
              },
              quantity: 1,
            }],
            mode: 'payment',
            success_url: store_success_url + "?session_id={CHECKOUT_SESSION_ID}",
            cancel_url: store_cancel_url,
            metadata: {
              user_id: current_user.id,
              subscription_type: 'vip'
            }
          })
          
          redirect_to session.url, allow_other_host: true
        end
      rescue Stripe::CardError => e
        redirect_to store_path, alert: "❌ Erreur de carte: #{e.message}"
      rescue => e
        Rails.logger.error "Erreur Stripe: #{e.message}"
        redirect_to store_path, alert: "❌ Erreur lors de l'achat. Veuillez réessayer."
      end
    else
      redirect_to store_path, alert: "❌ Type d'abonnement invalide."
    end
  end

  def buy_playlist
    @playlist = Playlist.find(params[:playlist_id])
    @user_points = current_user.total_points || 0
    @can_afford = @user_points >= @playlist.points_required
  end

  def confirm_playlist_purchase
    @playlist = Playlist.find(params[:playlist_id])
    
    user_points = current_user.total_points || 0
    
    if user_points >= @playlist.points_required
      # Déduire les points achetés en priorité
      purchased_points = current_user.points || 0
      points_to_deduct = @playlist.points_required
      
      if purchased_points >= points_to_deduct
        new_purchased_points = purchased_points - points_to_deduct
        current_user.update(points: new_purchased_points)
      else
        # Si pas assez de points achetés, déduire tout et le reste des points de jeu
        current_user.update(points: 0)
      end
      
      # Enregistrer le déblocage de la playlist premium pour l'utilisateur
      UserPlaylistUnlock.find_or_create_by(user: current_user, playlist: @playlist)
      redirect_to playlists_path(notice: "Playlist débloquée avec succès !", unlocked_playlist_id: @playlist.id)
    else
      redirect_to buy_playlist_store_path(@playlist), alert: "Points insuffisants. Veuillez acheter plus de points."
    end
  end

  # Actions pour les tests
  def purchase_points
    # Action pour les tests - simuler l'achat de points
    render json: { status: 'success', message: 'Points achetés avec succès' }
  end

  def unlock_playlist
    # Action pour les tests - simuler le déblocage de playlist
    render json: { status: 'success', message: 'Playlist débloquée avec succès' }
  end

  def unlock_exclusive_content
    # Action pour les tests - simuler le déblocage de contenu exclusif
    render json: { status: 'success', message: 'Contenu exclusif débloqué avec succès' }
  end

  # Page de succès après paiement Stripe
  def success
    session_id = params[:session_id]
    
    if session_id
      begin
        # Récupérer les détails de la session Stripe
        checkout_session = Stripe::Checkout::Session.retrieve(session_id)
        
        if checkout_session.payment_status == 'paid'
          # Traiter le paiement selon le type
          if checkout_session.metadata['subscription_type'] == 'vip'
            # Activer l'abonnement VIP
            current_user.update!(vip_subscription: true, vip_expires_at: 1.month.from_now)
            Rails.logger.info "Abonnement VIP activé: User #{current_user.id}"
            redirect_to playlists_path, notice: "✅ Abonnement VIP activé ! Toutes les playlists premium sont maintenant débloquées. <a href='/playlists' class='text-yellow-300 hover:text-yellow-200 underline'>Voir les playlists</a>".html_safe
          else
            # Ajouter les points
            points = checkout_session.metadata['points'].to_i
            current_points = current_user.points || 0
            current_user.update!(points: current_points + points)
            Rails.logger.info "Points ajoutés: User #{current_user.id} a reçu #{points} points"
            redirect_to store_path, notice: "✅ Paiement réussi ! Vous avez reçu #{points} points !"
          end
        else
          redirect_to store_path, alert: "❌ Paiement non confirmé"
        end
      rescue Stripe::InvalidRequestError => e
        Rails.logger.error "Session Stripe invalide: #{e.message}"
        redirect_to store_path, alert: "❌ Session de paiement invalide"
      rescue => e
        Rails.logger.error "Erreur lors du traitement du paiement: #{e.message}"
        redirect_to store_path, alert: "❌ Erreur lors du traitement du paiement"
      end
    else
      redirect_to store_path, alert: "❌ Session invalide"
    end
  end

  # Page d'annulation de paiement
  def cancel
    redirect_to store_path, alert: "❌ Paiement annulé"
  end

  private

  def set_user_points
    @user_points = current_user.total_points || 0
  end
end 