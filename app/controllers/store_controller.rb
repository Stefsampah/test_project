class StoreController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_points, only: [:index, :buy_playlist]

  def index
    @active_tab = params[:tab] || 'store'
    
    @point_packs = [
      { id: 0, name: t('store.packs.pack_100.name'), price: 0.99, points: 100, description: t('store.packs.pack_100.description') },
      { id: 1, name: t('store.packs.pack_500.name'), price: 1.99, points: 500, description: t('store.packs.pack_500.description') },
      { id: 2, name: t('store.packs.pack_1000.name'), price: 3.99, points: 1000, description: t('store.packs.pack_1000.description') },
      { id: 3, name: t('store.packs.pack_5000.name'), price: 4.99, points: 5000, description: t('store.packs.pack_5000.description') }
    ]

    @subscriptions = [
      { name: t('store.subscriptions.vip.name'), price: 9.99, description: t('store.subscriptions.vip.description') }
    ]

    # Exclure les playlists Challenge Reward (récompenses gagnées, pas achetées)
    # ET les playlists exclusives (débloquées uniquement via badges)
    reward_playlist_ids = Playlist.where("LOWER(title) LIKE ? OR LOWER(title) LIKE ? OR LOWER(title) LIKE ?", 
                                         "%reward%", "%récompense%", "%challenge%").pluck(:id)
    
    @premium_playlists = Playlist.where(premium: true, exclusive: [false, nil])
                                 .where.not(id: reward_playlist_ids)
                                 .order(:title)
    
    @unlocked_playlists = current_user.user_playlist_unlocks.includes(:playlist).map(&:playlist)
    @unlocked_exclusive_playlists = [] # Pas de playlists exclusives dans la boutique
    
    # Données pour "Ma boutique"
    if @active_tab == 'my_store'
      # Vérifier si l'utilisateur a un abonnement VIP actif
      vip_active = current_user.vip_subscription && current_user.vip_expires_at && current_user.vip_expires_at > Time.current
      
      # Playlists achetées
      @purchased_playlists = current_user.unlocked_playlists.includes(:videos).order(created_at: :desc)
      
      # Si l'utilisateur a un abonnement VIP actif, ajouter toutes les playlists premium
      if vip_active
        # Exclure les playlists Challenge Reward (récompenses gagnées, pas achetées)
        reward_playlist_ids = Playlist.where("LOWER(title) LIKE ? OR LOWER(title) LIKE ? OR LOWER(title) LIKE ?", 
                                             "%reward%", "%récompense%", "%challenge%").pluck(:id)
        
        # Récupérer toutes les playlists premium (sauf celles déjà débloquées individuellement)
        all_premium_playlists = Playlist.where(premium: true, exclusive: [false, nil])
                                        .where.not(id: reward_playlist_ids)
                                        .includes(:videos)
                                        .order(:title)
        
        # Combiner les playlists achetées individuellement avec toutes les playlists premium (sans doublons)
        purchased_ids = @purchased_playlists.pluck(:id)
        @purchased_playlists = (@purchased_playlists.to_a + all_premium_playlists.reject { |p| purchased_ids.include?(p.id) }).uniq
      end
      
      # Abonnements actifs
      @active_subscriptions = []
      if vip_active
        @active_subscriptions << {
          name: t('store.subscriptions.vip.name'),
          expires_at: current_user.vip_expires_at,
          active: true
        }
      end
    end
  end

  def buy_points
    pack_id = params[:pack_id]
    @point_packs = [
      { id: 0, name: t('store.packs.pack_100.name'), price: 0.99, points: 100, description: t('store.packs.pack_100.description') },
      { id: 1, name: t('store.packs.pack_500.name'), price: 1.99, points: 500, description: t('store.packs.pack_500.description') },
      { id: 2, name: t('store.packs.pack_1000.name'), price: 3.99, points: 1000, description: t('store.packs.pack_1000.description') },
      { id: 3, name: t('store.packs.pack_5000.name'), price: 4.99, points: 5000, description: t('store.packs.pack_5000.description') }
    ]
    
    @selected_pack = @point_packs.find { |pack| pack[:id] == pack_id.to_i }
    
    if @selected_pack
      begin
        if paypal_configured?
          # Mode réel - utiliser PayPal
          # PayPal nécessite des URLs absolues
          return_url = store_execute_url(payment_type: 'points', pack_id: pack_id, locale: I18n.locale, only_path: false)
          cancel_url = store_cancel_url(locale: I18n.locale, only_path: false)
          
          Rails.logger.info "Création paiement PayPal - Pack: #{pack_id}, Montant: #{@selected_pack[:price]}€, User: #{current_user.id}"
          Rails.logger.debug "Return URL: #{return_url}, Cancel URL: #{cancel_url}"
          
          result = ::PayPalService.create_payment(
            amount: @selected_pack[:price],
            currency: 'EUR',
            description: @selected_pack[:name],
            return_url: return_url,
            cancel_url: cancel_url,
            metadata: {
              user_id: current_user.id,
              pack_id: pack_id,
              points: @selected_pack[:points],
              payment_type: 'points'
            }
          )
          
          if result[:success]
            # Stocker le payment_id en session pour la vérification
            session[:paypal_payment_id] = result[:payment_id]
            session[:paypal_pack_id] = pack_id
            session[:paypal_points] = @selected_pack[:points]
            
            Rails.logger.info "Redirection vers PayPal: #{result[:approval_url]}"
            redirect_to result[:approval_url], allow_other_host: true
          else
            Rails.logger.error "❌ Erreur création paiement PayPal: #{result[:error]}"
            Rails.logger.error "Détails: #{result.inspect}"
            redirect_to store_path, alert: "❌ Erreur lors de l'achat: #{result[:error]}. Veuillez réessayer."
          end
        elsif current_user.admin?
          # Mode simulation réservé aux administrateurs
          current_points = current_user.points || 0
          new_points = current_points + @selected_pack[:points]
          current_user.update!(points: new_points)
          
          Rails.logger.info "Simulation d'achat administrateur: User #{current_user.id} a ajouté #{@selected_pack[:points]} points (#{@selected_pack[:price]}€)"
          
          redirect_to store_path, notice: t('store.messages.purchase_simulated', points: new_points)
        else
          Rails.logger.error "PayPal non configuré pour l'achat de points"
          redirect_to store_path, alert: t('store.messages.paypal_not_configured')
        end
      rescue => e
        Rails.logger.error "Erreur PayPal: #{e.message}"
        redirect_to store_path, alert: t('store.messages.purchase_error')
      end
    else
      redirect_to store_path, alert: t('store.messages.invalid_pack')
    end
  end

  def buy_subscription
    subscription_type = params[:subscription_type]
    
    if subscription_type == "vip"
      begin
        if paypal_me_enabled?
          # Utiliser PayPal.me (simple, pas besoin de SIRET)
          amount = 9.99
          paypal_me_link = "https://#{Rails.configuration.paypal_me[:link]}/#{amount}"
          
          # Stocker en session pour référence
          session[:pending_subscription] = {
            type: 'vip',
            amount: amount,
            user_id: current_user.id,
            email: current_user.email
          }
          
          Rails.logger.info "Redirection vers PayPal.me - User: #{current_user.id}, Montant: #{amount}€, Lien: #{paypal_me_link}"
          
          redirect_to paypal_me_link, allow_other_host: true
        elsif paypal_configured?
          # Mode réel - utiliser PayPal API (si configuré)
          return_url = store_execute_url(payment_type: 'subscription', subscription_type: 'vip', locale: I18n.locale, only_path: false)
          cancel_url = store_cancel_url(locale: I18n.locale, only_path: false)
          
          Rails.logger.info "Création paiement PayPal VIP - User: #{current_user.id}, Montant: 9.99€"
          Rails.logger.debug "Return URL: #{return_url}, Cancel URL: #{cancel_url}"
          
          result = ::PayPalService.create_payment(
            amount: 9.99,
            currency: 'EUR',
            description: t('store.subscriptions.vip.name'),
            return_url: return_url,
            cancel_url: cancel_url,
            metadata: {
              user_id: current_user.id,
              subscription_type: 'vip',
              payment_type: 'subscription'
            }
          )
          
          if result[:success]
            session[:paypal_payment_id] = result[:payment_id]
            session[:paypal_subscription_type] = 'vip'
            
            Rails.logger.info "Redirection vers PayPal: #{result[:approval_url]}"
            redirect_to result[:approval_url], allow_other_host: true
          else
            Rails.logger.error "❌ Erreur création paiement PayPal VIP: #{result[:error]}"
            redirect_to store_path, alert: "❌ Erreur lors de l'achat: #{result[:error]}. Veuillez réessayer."
          end
        elsif current_user.admin?
          # Mode simulation réservé aux administrateurs
          current_user.update!(vip_subscription: true, vip_expires_at: 1.month.from_now)
          
          Rails.logger.info "Simulation d'abonnement VIP par un administrateur: User #{current_user.id} a activé le VIP pour 9.99€"
          
          redirect_to playlists_path, notice: t('store.messages.vip_subscription_simulated').html_safe
        else
          Rails.logger.error "PayPal/PayPal.me non configuré pour l'abonnement VIP"
          redirect_to store_path, alert: t('store.messages.paypal_not_configured')
        end
      rescue => e
        Rails.logger.error "Erreur lors de l'achat d'abonnement: #{e.message}"
        redirect_to store_path, alert: t('store.messages.subscription_error')
      end
    else
      redirect_to store_path, alert: t('store.messages.invalid_subscription')
    end
  end

  def buy_playlist
    @playlist = Playlist.find(params[:playlist_id])
    @user_points = current_user.total_points || 0
    @can_afford = @user_points >= @playlist.points_required
  end

  def confirm_playlist_purchase
    playlist_id = params[:playlist_id].to_i
    return redirect_to store_path, alert: t('store.messages.invalid_playlist') if playlist_id.zero?
    
    @playlist = Playlist.find_by(id: playlist_id)
    return redirect_to store_path, alert: t('store.messages.playlist_not_found') unless @playlist
    
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
      redirect_to store_path(tab: 'my_store'), notice: t('store.messages.playlist_unlocked')
    else
      redirect_to buy_playlist_store_path(@playlist), alert: t('store.messages.insufficient_points')
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

  # Exécuter le paiement PayPal après approbation
  def execute_payment
    payment_id = params[:paymentId] || session[:paypal_payment_id]
    payer_id = params[:PayerID]
    payment_type = params[:payment_type] || 'points'
    
    if payment_id.blank? || payer_id.blank?
      redirect_to store_path, alert: t('store.messages.invalid_session')
      return
    end
    
    begin
      result = ::PayPalService.execute_payment(payment_id: payment_id, payer_id: payer_id)
      
      if result[:success]
        # Traiter le paiement selon le type
        if payment_type == 'subscription' || session[:paypal_subscription_type] == 'vip'
          # Activer l'abonnement VIP
          current_user.update!(vip_subscription: true, vip_expires_at: 1.month.from_now)
          Rails.logger.info "Abonnement VIP activé: User #{current_user.id}"
          
          # Nettoyer la session
          session.delete(:paypal_payment_id)
          session.delete(:paypal_subscription_type)
          
          redirect_to store_path(tab: 'my_store'), notice: t('store.messages.vip_subscription_activated')
        else
          # Ajouter les points
          points = session[:paypal_points] || params[:pack_id] ? get_points_for_pack(params[:pack_id] || session[:paypal_pack_id]) : 0
          current_points = current_user.points || 0
          current_user.update!(points: current_points + points)
          Rails.logger.info "Points ajoutés: User #{current_user.id} a reçu #{points} points"
          
          # Nettoyer la session
          session.delete(:paypal_payment_id)
          session.delete(:paypal_pack_id)
          session.delete(:paypal_points)
          
          redirect_to store_path(tab: 'my_store'), notice: t('store.messages.payment_success', points: points)
        end
      else
        Rails.logger.error "Erreur exécution paiement PayPal: #{result[:error]}"
        redirect_to store_path, alert: t('store.messages.payment_processing_error')
      end
    rescue => e
      Rails.logger.error "Erreur lors du traitement du paiement: #{e.message}"
      redirect_to store_path, alert: t('store.messages.payment_processing_error')
    end
  end

  # Page de succès après paiement PayPal (pour compatibilité)
  def success
    # Rediriger vers execute_payment si nécessaire
    if params[:paymentId] && params[:PayerID]
      redirect_to store_execute_url(paymentId: params[:paymentId], PayerID: params[:PayerID], payment_type: params[:payment_type])
    else
      redirect_to store_path, notice: t('store.messages.payment_success', points: 0)
    end
  end

  # Page d'annulation de paiement
  def cancel
    redirect_to store_path, alert: t('store.messages.payment_cancelled')
  end

  # Page de confirmation de paiement PayPal.me
  def payment_confirmation
    @pending_subscription = session[:pending_subscription]
    if @pending_subscription.nil?
      redirect_to store_path, alert: "Aucun paiement en attente"
    end
  end

  # Confirmer le paiement PayPal.me (pour activation manuelle par l'admin)
  def confirm_payment
    transaction_id = params[:transaction_id]
    user_email = params[:user_email]
    
    if transaction_id.blank? || user_email.blank?
      redirect_to store_payment_confirmation_path, alert: "Veuillez remplir tous les champs"
      return
    end

    user = User.find_by(email: user_email)
    unless user
      redirect_to store_payment_confirmation_path, alert: "Utilisateur non trouvé"
      return
    end

    # Stocker la transaction pour vérification manuelle par l'admin
    # L'admin devra vérifier dans PayPal et activer l'abonnement
    session[:payment_confirmation] = {
      transaction_id: transaction_id,
      user_email: user_email,
      user_id: user.id,
      timestamp: Time.current
    }

    Rails.logger.info "Confirmation de paiement PayPal.me - Transaction: #{transaction_id}, User: #{user.id} (#{user_email})"
    
    redirect_to store_path, notice: "✅ Merci ! Votre paiement est en cours de vérification. Votre abonnement VIP sera activé sous 24h après vérification."
  end

  private

  def get_points_for_pack(pack_id)
    packs = {
      '0' => 100,
      '1' => 500,
      '2' => 1000,
      '3' => 5000
    }
    packs[pack_id.to_s] || 0
  end

  def paypal_configured?
    Rails.configuration.paypal[:client_id].present? && Rails.configuration.paypal[:client_secret].present?
  end

  def paypal_me_enabled?
    Rails.configuration.paypal_me[:enabled] && Rails.configuration.paypal_me[:link].present?
  end

  def set_user_points
    @user_points = current_user.total_points || 0
  end
end 