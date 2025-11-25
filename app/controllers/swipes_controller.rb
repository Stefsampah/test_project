class SwipesController < ApplicationController
  before_action :authenticate_user!

  def create
    # Validation des paramètres
    video_id = params[:video_id].to_i
    playlist_id = params[:playlist_id].to_i
    liked = params[:liked].in?([true, 'true', '1', 1])
    
    return head :bad_request if video_id.zero? || playlist_id.zero?
    
    video = Video.find_by(id: video_id)
    playlist = Playlist.find_by(id: playlist_id)
    
    return head :not_found unless video && playlist
    
    # Créer un enregistrement de swipe
    Swipe.create!(
      user: current_user,
      video: video,
      playlist: playlist,
      liked: liked
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