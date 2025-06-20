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

    @premium_playlists = Playlist.where(premium: true)
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
      # Ici vous pouvez ajouter la logique de paiement
      # Pour l'instant, on simule l'achat
      current_user.update(points: current_user.points + @selected_pack[:points])
      redirect_to store_path, notice: "Achat réussi ! #{@selected_pack[:points]} points ajoutés à votre compte."
    else
      redirect_to store_path, alert: "Pack de points invalide."
    end
  end

  def buy_subscription
    subscription_type = params[:subscription_type]
    
    if subscription_type == "vip"
      # Ici vous pouvez ajouter la logique de paiement pour l'abonnement VIP
      current_user.update(vip_subscription: true, vip_expires_at: 1.month.from_now)
      redirect_to store_path, notice: "Abonnement VIP activé ! Toutes les playlists premium sont maintenant débloquées."
    else
      redirect_to store_path, alert: "Type d'abonnement invalide."
    end
  end

  def buy_playlist
    @playlist = Playlist.find(params[:playlist_id])
    @user_points = current_user.points
    @can_afford = @user_points >= @playlist.points_required
  end

  def confirm_playlist_purchase
    @playlist = Playlist.find(params[:playlist_id])
    
    if current_user.points >= @playlist.points_required
      current_user.update(points: current_user.points - @playlist.points_required)
      # Ici vous pouvez ajouter une logique pour débloquer la playlist pour l'utilisateur
      redirect_to playlist_path(@playlist), notice: "Playlist débloquée avec succès !"
    else
      redirect_to buy_playlist_store_path(@playlist), alert: "Points insuffisants. Veuillez acheter plus de points."
    end
  end

  private

  def set_user_points
    @user_points = current_user.points
  end
end 