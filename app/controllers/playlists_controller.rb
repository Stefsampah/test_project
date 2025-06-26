class PlaylistsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    # Récupérer toutes les playlists et les trier
    @standard_playlists = Playlist.where(premium: [false, nil]).order(:id)
    @premium_playlists = Playlist.where(premium: true).order(:id)
    @unlocked_playlists = []
    if user_signed_in?
      # Récupérer les playlists premium débloquées par l'utilisateur
      unlocked_playlist_ids = UserPlaylistUnlock.where(user: current_user).pluck(:playlist_id)
      @unlocked_playlists = Playlist.where(id: unlocked_playlist_ids, premium: true)
      @premium_playlists = @premium_playlists.where.not(id: unlocked_playlist_ids)
    end
    
    # Récupérer les playlists utilisées par l'utilisateur connecté
    @user_playlists = current_user.playlists.distinct if user_signed_in?
  end

  def show
    @playlist = Playlist.find(params[:id])
    
    # Vérifier si l'utilisateur a accès à cette playlist premium
    if @playlist.premium? && user_signed_in?
      unless UserPlaylistUnlock.exists?(user: current_user, playlist: @playlist) || current_user.total_points >= 500
        redirect_to playlists_path, alert: "Vous avez besoin d'au moins 500 points ou d'avoir débloqué cette playlist premium."
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
