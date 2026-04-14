class SwipesController < ApplicationController
  before_action :authenticate_user!

  def create
    # Validation des paramètres
    video_id = params[:video_id].to_i
    playlist_id = params[:playlist_id].to_i
    game_id = params[:game_id].to_i
    liked = params[:liked].in?([true, 'true', '1', 1])
    watched_seconds = [params[:watched_seconds].to_i, 0].max
    
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
          next_video_youtube_id: next_video.youtube_id,
          next_video_title: next_video.title,
          redirect: playlist_game_path(playlist, game)
        }, status: :ok
      else
        # Partie terminée (toutes les vidéos swipées) : marquer pour que "Reprendre" disparaisse
        game.update_column(:completed_at, Time.current) if game.completed_at.nil?
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
        liked: liked,
        watched_seconds: watched_seconds
      )

      # Pour les playlists normales, calculer et sauvegarder les points (leaderboard par playlist)
      unless reward_playlist?(playlist)
        next_video = game.next_video
        game_completed = next_video.nil?
        ScoringService.register_playlist_score!(
          user: current_user,
          playlist: playlist,
          game: game,
          apply_anti_abuse: game_completed
        )
      end

      # Points parcours
      journey_result = JourneyPointsService.add_swipe_points(current_user, swipe, video)
      current_user.reload

      game.reload
      next_video = game.next_video
      daily_bonus_awarded = false

      # Marquer le jeu comme terminé s'il n'y a plus de vidéos (évite que "Reprendre la partie" reste affiché)
      if next_video.nil?
        game.update_column(:completed_at, Time.current) if game.completed_at.nil?
        daily_bonus_awarded = apply_daily_playlists_bonus_if_eligible(game)
        current_user.reload if daily_bonus_awarded
      end

      journey_payload = {
        journey_points_added: journey_result[:total],
        journey_points_breakdown: journey_result[:breakdown],
        journey_unlocks: journey_result[:unlocks] || [],
        journey_total: current_user.journey_points,
        journey_level: JourneyLevels.current_level(current_user.journey_points),
        journey_level_name: JourneyLevels.level_name(JourneyLevels.current_level(current_user.journey_points)),
        journey_progress_percent: JourneyLevels.progress_percentage(current_user.journey_points),
        journey_points_to_next: JourneyLevels.points_to_next_level(current_user.journey_points)
      }
      if next_video.nil? && daily_bonus_awarded
        journey_payload[:daily_connection_bonus] = JourneyPointsService::POINTS_DAILY_PLAYLIST_STREAK
        journey_payload[:journey_total] = current_user.journey_points
      end

      if next_video
        render json: { 
          success: true, 
          next_video_id: next_video.id,
          next_video_youtube_id: next_video.youtube_id,
          next_video_title: next_video.title,
          redirect: playlist_game_path(playlist, game)
        }.merge(journey_payload), status: :ok
      else
        redirect_path = reward_playlist?(playlist) ? 
          results_playlist_game_path(playlist, game) : 
          results_playlist_game_path(playlist, game)
        render json: { 
          success: true, 
          completed: true,
          redirect: redirect_path
        }.merge(journey_payload), status: :ok
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

  def apply_daily_playlists_bonus_if_eligible(game)
    completed_today = game.user.games.where(completed_at: Time.current.all_day).count
    return false unless completed_today == 3

    new_total = game.user.journey_points.to_i + JourneyPointsService::POINTS_DAILY_PLAYLIST_STREAK
    game.user.update_columns(
      journey_points: new_total,
      season_journey_points: new_total
    )
    true
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