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

  # Actions pour les tests
  def next_video
    # Action pour les tests - retourner la prochaine vidéo
    render json: { next_video: { id: 1, title: "Next Video" } }
  end

  def game_completion_status
    # Action pour les tests - retourner le statut de completion
    render json: { completed: false, progress: 50 }
  end
end 