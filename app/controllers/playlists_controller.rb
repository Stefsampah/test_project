class PlaylistsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    # Récupérer toutes les playlists et les trier (exclure les playlists cachées)
    @standard_playlists = Playlist.where(premium: [false, nil], hidden: [false, nil]).order(:id)
    @premium_playlists = Playlist.where(premium: true, exclusive: [false, nil], hidden: [false, nil]).order(:id)
    @exclusive_playlists = Playlist.where(exclusive: true, hidden: [false, nil]).order(:id)
    @unlocked_playlists = []
    @unlocked_exclusive_playlists = []
    
    if user_signed_in?
      # Vérifier si l'utilisateur a un abonnement VIP actif
      has_vip = current_user.vip_subscription && current_user.vip_expires_at && current_user.vip_expires_at > Time.current
      
      if has_vip
        # Si VIP actif, toutes les playlists premium sont débloquées (sauf exclusives)
        @unlocked_playlists = @premium_playlists
        @premium_playlists = []
      else
        # Sinon, récupérer les playlists premium débloquées par l'utilisateur
        unlocked_playlist_ids = UserPlaylistUnlock.where(user: current_user).pluck(:playlist_id)
        @unlocked_playlists = Playlist.where(id: unlocked_playlist_ids, premium: true, exclusive: [false, nil])
        @premium_playlists = @premium_playlists.where.not(id: unlocked_playlist_ids)
      end
      
      # Gérer les playlists exclusives - seulement pour ceux qui ont gagné la récompense
      # Vérifier quels badges l'utilisateur a et quelles playlists exclusives ils débloquent
      user_badge_ids = current_user.user_badges.pluck(:badge_id)
      unlocked_exclusive_playlist_ids = BadgePlaylistUnlock.where(badge_id: user_badge_ids).pluck(:playlist_id)
      
      if unlocked_exclusive_playlist_ids.any?
        @unlocked_exclusive_playlists = @exclusive_playlists.where(id: unlocked_exclusive_playlist_ids)
        @exclusive_playlists = @exclusive_playlists.where.not(id: unlocked_exclusive_playlist_ids)
      else
        @unlocked_exclusive_playlists = []
      end
      
      # Trier les playlists avec les non jouées en premier
      played_playlist_ids = current_user.scores.pluck(:playlist_id)
      
      # Trier les playlists standard : non jouées en premier
      unplayed_standard = @standard_playlists.where.not(id: played_playlist_ids)
      played_standard = @standard_playlists.where(id: played_playlist_ids)
      @standard_playlists = unplayed_standard + played_standard
      
      # Trier les playlists premium : non jouées en premier
      if @premium_playlists.respond_to?(:where)
        unplayed_premium = @premium_playlists.where.not(id: played_playlist_ids)
        played_premium = @premium_playlists.where(id: played_playlist_ids)
        @premium_playlists = unplayed_premium + played_premium
      end
      
      # Trier les playlists débloquées : non jouées en premier
      if @unlocked_playlists.respond_to?(:where)
        unplayed_unlocked = @unlocked_playlists.where.not(id: played_playlist_ids)
        played_unlocked = @unlocked_playlists.where(id: played_playlist_ids)
        @unlocked_playlists = unplayed_unlocked + played_unlocked
      end
      
      # Trier les playlists exclusives débloquées : non jouées en premier
      if @unlocked_exclusive_playlists.respond_to?(:where)
        unplayed_exclusive = @unlocked_exclusive_playlists.where.not(id: played_playlist_ids)
        played_exclusive = @unlocked_exclusive_playlists.where(id: played_playlist_ids)
        @unlocked_exclusive_playlists = unplayed_exclusive + played_exclusive
      end
    end
    
    # Récupérer les playlists jouées par l'utilisateur connecté (avec score existant)
    if user_signed_in?
      played_playlist_ids = current_user.scores.pluck(:playlist_id)
      @user_playlists = Playlist.where(id: played_playlist_ids).order(:id)
    end
  end

  def show
    @playlist = Playlist.find(params[:id])
    
    # Empêcher l'accès aux playlists cachées
    if @playlist.hidden?
      redirect_to playlists_path, alert: "Cette playlist n'est pas accessible."
      return
    end
    
    # Vérifier si l'utilisateur a accès à cette playlist premium
    if @playlist.premium? && user_signed_in?
      has_vip = current_user.vip_subscription && current_user.vip_expires_at && current_user.vip_expires_at > Time.current
      has_unlock = UserPlaylistUnlock.exists?(user: current_user, playlist: @playlist)
      has_points = current_user.total_points >= 500
      
      unless has_vip || has_unlock || has_points
        redirect_to playlists_path, alert: "Vous avez besoin d'au moins 500 points, d'avoir débloqué cette playlist premium, ou d'avoir un abonnement VIP actif."
      end
    end
    
    # Récupérer les vidéos non encore swipées par l'utilisateur s'il est connecté
    if user_signed_in?
      swiped_video_ids = current_user.swipes.where(playlist: @playlist).pluck(:video_id)
      @current_video = @playlist.videos.where.not(id: swiped_video_ids).first
    else
      @current_video = @playlist.videos.first
    end
  end
end
