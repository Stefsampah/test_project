class PlaylistsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    # Récupérer toutes les playlists et les trier
    @standard_playlists = Playlist.where(premium: [false, nil]).order(:id)
    @premium_playlists = Playlist.where(premium: true).order(:id)
    
    # Récupérer les playlists utilisées par l'utilisateur connecté
    @user_playlists = current_user.playlists.distinct if user_signed_in?
  end

  def show
    @playlist = Playlist.find(params[:id])
    
    # Vérifier si l'utilisateur a accès à cette playlist premium
    if @playlist.premium? && user_signed_in?
      # L'utilisateur doit avoir au moins 500 points pour accéder aux playlists premium
      redirect_to playlists_path, alert: "Vous avez besoin d'au moins 500 points pour accéder à cette playlist premium." unless current_user.total_points >= 500
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
