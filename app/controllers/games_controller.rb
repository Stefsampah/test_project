class GamesController < ApplicationController
  MAX_DAILY_GAMES_FREE = 7
  layout 'shorts', only: [:show, :swipe, :results, :reward_results]
  
  before_action :authenticate_user!
  before_action :set_playlist, only: [:new, :create, :show, :swipe, :results]
  before_action :set_game, only: [:show, :swipe, :results]
  before_action :check_premium_access, only: [:new, :create]

  def new
    # Pour les playlists récompenses, permettre de relancer même si terminées
    if reward_playlist?(@playlist)
      # Vérifier si l'utilisateur a un jeu non terminé pour cette playlist
      existing_game = current_user.games.where(playlist: @playlist).where(completed_at: nil).last
      
      if existing_game
        redirect_to playlist_game_path(@playlist, existing_game), notice: "Vous avez une partie en cours !"
      else
        @game = Game.new(playlist: @playlist, user: current_user)
      end
      return
    end
    
    # Pour les playlists normales
    # Si une partie est en cours sur cette playlist, on la reprend
    existing_game = current_user.games.where(playlist: @playlist).where(completed_at: nil).last
    if existing_game
      redirect_to playlist_game_path(@playlist, existing_game), notice: "Vous avez une partie en cours !"
      return
    end

    # Cooldown rejouabilité: pas 2 fois la même playlist le même jour
    completed_game = current_user.games.where(playlist: @playlist).where(completed_at: Time.current.all_day).last
    if completed_game
      redirect_to results_playlist_game_path(@playlist, completed_game), alert: "Vous avez déjà terminé cette playlist aujourd'hui !"
      return
    end

    @game = Game.new(playlist: @playlist, user: current_user)
    render layout: 'shorts'
  end

  def create
    # Pour les playlists récompenses, permettre de relancer même si terminées
    if reward_playlist?(@playlist)
      # Vérifier si l'utilisateur a un jeu non terminé pour cette playlist
      existing_game = current_user.games.where(playlist: @playlist).where(completed_at: nil).last
      
      if existing_game
        redirect_to playlist_game_path(@playlist, existing_game), notice: "Vous avez une partie en cours !"
        return
      end
      
      # Créer une nouvelle partie pour les playlists récompenses
      @game = Game.new(playlist: @playlist, user: current_user)
      
      if @game.save
        redirect_to playlist_game_path(@playlist, @game), notice: "Partie créée avec succès !"
      else
        render :new, status: :unprocessable_entity
      end
      return
    end
    
    # Pour les playlists normales : rejouable, sauf si déjà terminée aujourd'hui
    existing_game = current_user.games.where(playlist: @playlist).where(completed_at: nil).last
    if existing_game
      redirect_to playlist_game_path(@playlist, existing_game), notice: "Vous avez une partie en cours !"
      return
    end

    completed_game = current_user.games.where(playlist: @playlist).where(completed_at: Time.current.all_day).last
    if completed_game
      redirect_to results_playlist_game_path(@playlist, completed_game), alert: "Vous avez déjà terminé cette playlist aujourd'hui !"
      return
    end

    @game = Game.new(playlist: @playlist, user: current_user)
    
    if @game.save
      redirect_to playlist_game_path(@playlist, @game), notice: "Partie créée avec succès !"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    if @game.completed?
      # Récupérer les informations nécessaires
      @score = Score.find_by(user: current_user, playlist: @game.playlist)
      @playlist = @game.playlist
      
      # Calcul des vidéos likées et non likées
      swipes = @game.swipes.includes(:video)
      @liked_videos = swipes.where(action: "like").map(&:video)
      @not_liked_videos = @playlist.videos - @liked_videos # Toutes les vidéos - vidéos likées

      # Vérifier si c'est une playlist récompense
      if reward_playlist?(@playlist)
        # Pour les playlists récompenses, afficher seulement un message de félicitations
        render :reward_results, layout: 'shorts'
      else
        # Calcul de la position dans le classement pour les playlists normales
        scores = Score.where(playlist: @playlist).order(points: :desc)
        user_score_index = scores.pluck(:user_id).index(current_user.id)
        @position = user_score_index ? user_score_index + 1 : scores.count + 1

        # Affiche la vue des résultats normaux
        render :results, layout: 'shorts'
      end
    else
      # Continuer le jeu (affichez la vue normale du jeu)
      render :show, layout: 'shorts'
    end
  end

  def results
    # Récupérer les informations nécessaires
    @score = Score.find_by(user: current_user, playlist: @game.playlist)
    @playlist = @game.playlist
    
    # Vérifier si c'est une playlist récompense
    if reward_playlist?(@playlist)
      # Pour les playlists récompenses, rediriger vers reward_results
      render :reward_results, layout: 'shorts'
      return
    end
    
    # Si pas de score, créer un score basé sur le jeu (seulement pour les playlists normales)
    unless @score
      @score = Score.create!(
        user: current_user,
        playlist: @playlist,
        points: ScoringService.final_game_score(@game)
      )
    end
    
    # Calcul des vidéos likées et non likées
    swipes = @game.swipes.includes(:video)
    @liked_videos = swipes.where(action: "like").map(&:video)
    @not_liked_videos = @playlist.videos - @liked_videos # Toutes les vidéos - vidéos likées

    # Calcul de la position dans le classement
    scores = Score.where(playlist: @playlist).order(points: :desc)
    user_score_index = scores.pluck(:user_id).index(current_user.id)
    @position = user_score_index ? user_score_index + 1 : scores.count + 1
    
    # Utiliser le layout par défaut au lieu de 'shorts' pour afficher tous les éléments visuels correctement
    render layout: 'application'
  end

  def reward_results
    # Méthode spécifique pour les résultats des playlists récompenses
    @playlist = @game.playlist
    
    # Calcul des vidéos likées et non likées
    swipes = @game.swipes.includes(:video)
    @liked_videos = swipes.where(action: "like").map(&:video)
    @not_liked_videos = @playlist.videos - @liked_videos
    
    render layout: 'shorts'
  end

  def swipe
    # Empêcher de swiper si le jeu est déjà terminé
    if @game.completed?
      if request.format.json?
        render json: { error: "Cette partie est déjà terminée !", redirect: results_playlist_game_path(@game.playlist, @game) }, status: :unprocessable_entity
      else
        redirect_to results_playlist_game_path(@game.playlist, @game), alert: "Cette partie est déjà terminée !"
      end
      return
    end

    Rails.logger.info "Params reçus : #{params.inspect}"

    video = @game.current_video
    
    # Vérifier qu'une vidéo existe
    unless video
      Rails.logger.error "Aucune vidéo trouvée pour le jeu #{@game.id}"
      if request.format.json?
        render json: { error: "Aucune vidéo disponible." }, status: :not_found
      else
        redirect_to results_playlist_game_path(@game.playlist, @game), alert: "Aucune vidéo disponible."
      end
      return
    end
    
    action = params[:direction] == "like" ? "like" : "dislike"
    liked_value = (action == "like")
    watched_seconds = [params[:watched_seconds].to_i, 0].max

    Rails.logger.info "Vidéo actuelle : #{video&.title} | Utilisateur : #{current_user&.id} | Action : #{action}"

    # Vérifier que la vidéo n'a pas déjà été swipée
    existing_swipe = @game.swipes.find_by(video: video)
    if existing_swipe
      Rails.logger.warn "Swipe déjà existant pour cette vidéo"
      @game.reload
      next_video = @game.next_video
      
      if next_video
        if request.format.json?
          render json: { success: true, next_video_id: next_video.id, redirect: playlist_game_path(@game.playlist, @game) }, status: :ok
        else
          redirect_to playlist_game_path(@game.playlist, @game), notice: "Vidéo #{action} enregistrée !"
        end
      else
        if request.format.json?
          render json: { success: true, completed: true, redirect: results_playlist_game_path(@game.playlist, @game) }, status: :ok
        else
          redirect_to results_playlist_game_path(@game.playlist, @game), notice: "Félicitations ! Vous avez terminé la playlist !"
        end
      end
      return
    end

    journey_payload = {}

    # Utiliser une transaction avec retry pour gérer les verrouillages SQLite
    retries = 3
    begin
      ActiveRecord::Base.transaction do
        # Créer le swipe
        swipe = @game.swipes.create!(
          user: current_user,
          video: video,
          action: action,
          liked: liked_value,
          playlist: @playlist,
          watched_seconds: watched_seconds
        )

        # Pour les playlists récompenses, pas de système de points
        # Pour les playlists normales, calculer et sauvegarder les points
        unless reward_playlist?(@playlist)
          next_video = @game.next_video
          game_completed = next_video.nil?
          ScoringService.register_playlist_score!(
            user: current_user,
            playlist: @playlist,
            game: @game,
            apply_anti_abuse: game_completed
          )
        end

        # Points parcours/saison: aligner ce flux avec SwipesController#create
        journey_result = JourneyPointsService.add_swipe_points(current_user, swipe, video)
        current_user.reload
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

        @game.reload

        next_video = @game.next_video
        Rails.logger.info "Vidéo suivante : #{next_video&.title}"

        # Marquer le jeu comme terminé s'il n'y a plus de vidéos
        if !next_video && @game.completed?
          @game.update(completed_at: Time.current)
          apply_daily_playlists_bonus_if_eligible
          current_user.reload
          journey_payload[:journey_total] = current_user.journey_points
          if current_user.games.where(completed_at: Time.current.all_day).count == 3
            journey_payload[:daily_connection_bonus] = JourneyPointsService::POINTS_DAILY_PLAYLIST_STREAK
          end
        end

        if next_video
          if request.format.json?
            render json: {
              success: true,
              next_video_id: next_video.id,
              redirect: playlist_game_path(@game.playlist, @game)
            }.merge(journey_payload), status: :ok
          else
            redirect_to playlist_game_path(@game.playlist, @game), notice: "Vidéo #{action} enregistrée !"
          end
        else
          redirect_path = results_playlist_game_path(@game.playlist, @game)
          message = reward_playlist?(@playlist) ? 
            "Félicitations ! Vous avez terminé la playlist récompense !" : 
            "Félicitations ! Vous avez terminé la playlist !"
          
          if request.format.json?
            render json: {
              success: true,
              completed: true,
              redirect: redirect_path
            }.merge(journey_payload), status: :ok
          else
            redirect_to redirect_path, notice: message
          end
        end
      end
    rescue ActiveRecord::StatementInvalid => e
      if e.message.include?('database is locked') && retries > 0
        retries -= 1
        sleep(0.1 * (3 - retries)) # Attendre progressivement plus longtemps
        retry
      else
        Rails.logger.error "Erreur lors du swipe : #{e.message}"
        error_message = "Erreur lors de l'enregistrement. Veuillez réessayer."
        if request.format.json?
          render json: { error: error_message }, status: :internal_server_error
        else
          redirect_to playlist_game_path(@game.playlist, @game), alert: error_message
        end
      end
    rescue => e
      Rails.logger.error "Erreur inattendue lors du swipe : #{e.message} - #{e.backtrace.first(5).join("\n")}"
      error_message = "Une erreur est survenue. Veuillez réessayer."
      if request.format.json?
        render json: { error: error_message }, status: :internal_server_error
      else
        redirect_to playlist_game_path(@game.playlist, @game), alert: error_message
      end
    end
  end

  def play
    @playlist = Playlist.find(params[:playlist_id])
    
    # Pour les playlists récompenses, permettre de relancer même si terminées
    if reward_playlist?(@playlist)
      # Vérifier si l'utilisateur a un jeu non terminé pour cette playlist
      existing_game = current_user.games.where(playlist: @playlist).where(completed_at: nil).last
      
      if existing_game
        redirect_to playlist_game_path(@playlist, existing_game), notice: "Vous avez une partie en cours !"
        return
      end
      
      # Créer une nouvelle partie pour les playlists récompenses
      @game = Game.new(playlist: @playlist, user: current_user)
      
      if @game.save
        redirect_to playlist_game_path(@playlist, @game), notice: "Nouvelle partie lancée !"
      else
        redirect_to playlists_path, alert: "Impossible de lancer une nouvelle partie."
      end
      return
    end
    
    # Pour les playlists normales, cooldown 24h sur la même playlist
    completed_game = current_user.games.where(playlist: @playlist).where(completed_at: Time.current.all_day).last
    
    if completed_game
      redirect_to results_playlist_game_path(@playlist, completed_game), alert: "Vous avez déjà terminé cette playlist aujourd'hui !"
      return
    end
    
    # Vérifier si l'utilisateur a un jeu non terminé pour cette playlist
    existing_game = current_user.games.where(playlist: @playlist).where(completed_at: nil).last
    
    if existing_game
      redirect_to playlist_game_path(@playlist, existing_game), notice: "Vous avez une partie en cours !"
      return
    end
    
    @game = Game.new(playlist: @playlist, user: current_user)
    
    if @game.save
      redirect_to playlist_game_path(@playlist, @game), notice: "Nouvelle partie lancée !"
    else
      redirect_to playlists_path, alert: "Impossible de lancer une nouvelle partie."
    end
  end

  private

  def set_playlist
    @playlist = Playlist.find(params[:playlist_id])
  end

  def set_game
    @game = Game.find(params[:id])
  end
  
  def check_premium_access
    return if current_user.vip?

    # Dev-only bypass: on veut tester le gameplay même si on a déjà atteint la limite journalière.
    return if Rails.env.development? || Rails.env.test?

    games_today = current_user.games.where(created_at: Time.current.all_day).count
    if games_today >= MAX_DAILY_GAMES_FREE
      redirect_to playlists_path, alert: "Tu as déjà joué #{MAX_DAILY_GAMES_FREE} playlists aujourd'hui. Reviens demain ou deviens VIP pour jouer sans limite."
    end
  end

  def reward_playlist?(playlist)
    # Définir ici les playlists récompenses
    # Vérifier si le titre contient "reward", "récompense" ou "challenge"
    title = playlist.title.downcase
    title.include?("reward") || title.include?("récompense") || title.include?("challenge")
  end

  def apply_daily_playlists_bonus_if_eligible
    completed_today = current_user.games.where(completed_at: Time.current.all_day).count
    return unless completed_today == 3

    new_total = current_user.journey_points.to_i + JourneyPointsService::POINTS_DAILY_PLAYLIST_STREAK
    current_user.update_columns(
      journey_points: new_total,
      season_journey_points: new_total
    )
  end
end
