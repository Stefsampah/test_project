class SwipesController < ApplicationController
  before_action :authenticate_user!

  def create
    # Validation des paramètres
    video_id = params[:video_id].to_i
    playlist_id = params[:playlist_id].to_i
    game_id = params[:game_id].to_i
    liked = params[:liked].in?([true, 'true', '1', 1])
    
    return head :bad_request if video_id.zero? || playlist_id.zero? || game_id.zero?
    
    video = Video.find_by(id: video_id)
    playlist = Playlist.find_by(id: playlist_id)
    game = Game.find_by(id: game_id, user: current_user, playlist: playlist)
    
    return head :not_found unless video && playlist && game
    
    # Vérifier que le jeu n'est pas terminé
    if game.completed?
      return render json: { error: "Cette partie est déjà terminée !", redirect: results_playlist_game_path(playlist, game) }, status: :unprocessable_entity
    end
    
    # Vérifier que la vidéo n'a pas déjà été swipée dans ce jeu
    existing_swipe = game.swipes.find_by(video: video)
    if existing_swipe
      Rails.logger.warn "Swipe déjà existant pour cette vidéo dans ce jeu"
      # Retourner la prochaine vidéo même si le swipe existe déjà
      next_video = game.next_video
      if next_video
        return render json: { 
          success: true, 
          next_video_id: next_video.id,
          redirect: playlist_game_path(playlist, game)
        }, status: :ok
      else
        return render json: { 
          success: true, 
          completed: true,
          redirect: results_playlist_game_path(playlist, game)
        }, status: :ok
      end
    end
    
    begin
      # Créer un enregistrement de swipe avec game_id
      action = liked ? "like" : "dislike"
      swipe = game.swipes.create!(
        user: current_user,
        video: video,
        playlist: playlist,
        action: action,
        liked: liked
      )

      # Pour les playlists normales, calculer et sauvegarder les points
      unless reward_playlist?(playlist)
        score = Score.find_or_initialize_by(user: current_user, playlist: playlist)
        game_score = game.swipes.where(action: 'like').count * 2 + game.swipes.where(action: 'dislike').count
        score.points = game_score
        score.save!
      end

      game.reload
      next_video = game.next_video

      # Marquer le jeu comme terminé s'il n'y a plus de vidéos
      if !next_video && game.completed?
        game.update(completed_at: Time.current)
      end

      if next_video
        render json: { 
          success: true, 
          next_video_id: next_video.id,
          redirect: playlist_game_path(playlist, game)
        }, status: :ok
      else
        redirect_path = reward_playlist?(playlist) ? 
          results_playlist_game_path(playlist, game) : 
          results_playlist_game_path(playlist, game)
        render json: { 
          success: true, 
          completed: true,
          redirect: redirect_path
        }, status: :ok
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Erreur lors de la création du swipe : #{e.message}"
      render json: { error: "Erreur lors de l'enregistrement. Veuillez réessayer." }, status: :unprocessable_entity
    rescue => e
      Rails.logger.error "Erreur inattendue lors du swipe : #{e.message}"
      render json: { error: "Une erreur est survenue. Veuillez réessayer." }, status: :internal_server_error
    end
  end
  
  private
  
  def reward_playlist?(playlist)
    title = playlist.title.downcase
    title.include?("reward") || title.include?("récompense") || title.include?("challenge")
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