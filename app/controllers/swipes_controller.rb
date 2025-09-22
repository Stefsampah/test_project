class SwipesController < ApplicationController
  before_action :authenticate_user!

  def create
    video = Video.find(params[:video_id])
    playlist = Playlist.find(params[:playlist_id])
    
    # Créer un enregistrement de swipe
    Swipe.create!(
      user: current_user,
      video: video,
      playlist: playlist,
      liked: params[:liked]
    )

    # Mettre à jour le score si c'est un like ET qu'un jeu existe pour cette playlist
    if params[:liked]
      # Vérifier qu'un jeu existe pour cette playlist et cet utilisateur
      game = Game.find_by(user: current_user, playlist: playlist)
      
      if game
        score = Score.find_or_create_by!(user: current_user, playlist: playlist)
        score.increment!(:points)
      else
        Rails.logger.warn "Tentative de création de score sans jeu valide pour #{current_user.email} et playlist '#{playlist.title}'"
      end
    end

    head :ok
  end
end 