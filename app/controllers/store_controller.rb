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
    # Fonctionnalité temporairement désactivée en attendant l'implémentation du système d'achat in-app
    redirect_to store_path, alert: "Les achats de points ne sont pas encore disponibles. Le système d'achat in-app est en cours de développement."
    
    # Code original commenté pour référence future :
    # pack_id = params[:pack_id]
    # @point_packs = [
    #   { id: 0, name: "Pack 100 points", price: 0.99, points: 100, description: "Idéal pour tester sans engagement" },
    #   { id: 1, name: "Pack 500 points", price: 1.99, points: 500, description: "Un bon équilibre avec des bonus inclus" },
    #   { id: 2, name: "Pack 1000 points", price: 3.99, points: 1000, description: "Offre la meilleure valeur avec un bonus supplémentaire" },
    #   { id: 3, name: "Pack 5000 points", price: 4.99, points: 5000, description: "Offre la meilleure valeur avec un bonus supplémentaire" }
    # ]
    #
    # @selected_pack = @point_packs.find { |pack| pack[:id] == pack_id.to_i }
    # 
    # if @selected_pack
    #   # Ici vous pouvez ajouter la logique de paiement
    #   # Pour l'instant, on simule l'achat
    #   current_points = current_user.points || 0
    #   new_points = current_points + @selected_pack[:points]
    #   current_user.update(points: new_points)
    #   redirect_to store_path, notice: "Vous avez désormais #{new_points} points !"
    # else
    #   redirect_to store_path, alert: "Pack de points invalide."
    # end
  end

  def buy_subscription
    # Fonctionnalité temporairement désactivée en attendant l'implémentation du système d'achat in-app
    redirect_to store_path, alert: "Les abonnements ne sont pas encore disponibles. Le système d'achat in-app est en cours de développement."
    
    # Code original commenté pour référence future :
    # subscription_type = params[:subscription_type]
    # 
    # if subscription_type == "vip"
    #   # Ici vous pouvez ajouter la logique de paiement pour l'abonnement VIP
    #   current_user.update(vip_subscription: true, vip_expires_at: 1.month.from_now)
    #   redirect_to playlists_path, notice: "Abonnement VIP activé ! Toutes les playlists premium sont maintenant débloquées. <a href='/playlists' class='text-yellow-300 hover:text-yellow-200 underline'>Voir les playlists</a>".html_safe
    # else
    #   redirect_to store_path, alert: "Type d'abonnement invalide."
    # end
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

  private

  def set_user_points
    @user_points = current_user.total_points || 0
  end
end 