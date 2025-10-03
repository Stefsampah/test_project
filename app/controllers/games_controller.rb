class GamesController < ApplicationController
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
    
    # Pour les playlists normales, vérifier si déjà terminée
    # Vérifier si l'utilisateur a déjà terminé une partie pour cette playlist
    completed_game = current_user.games.where(playlist: @playlist).where.not(completed_at: nil).last
    
    if completed_game
      redirect_to results_playlist_game_path(@playlist, completed_game), alert: "Vous avez déjà terminé cette playlist !"
      return
    end
    
    # Vérifier si l'utilisateur a un jeu non terminé pour cette playlist
    existing_game = current_user.games.where(playlist: @playlist).where(completed_at: nil).last
    
    if existing_game
      redirect_to playlist_game_path(@playlist, existing_game), notice: "Vous avez une partie en cours !"
    else
      @game = Game.new(playlist: @playlist, user: current_user)
    end
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
    
    # Pour les playlists normales, vérifier si déjà terminée
    # Vérifier si l'utilisateur a déjà terminé une partie pour cette playlist
    completed_game = current_user.games.where(playlist: @playlist).where.not(completed_at: nil).last
    
    if completed_game
      redirect_to results_playlist_game_path(@playlist, completed_game), alert: "Vous avez déjà terminé cette playlist !"
      return
    end

    # Vérifier si l'utilisateur a un jeu non terminé pour cette playlist
    existing_game = current_user.games.where(playlist: @playlist).where(completed_at: nil).last
    
    if existing_game
      redirect_to playlist_game_path(@playlist, existing_game), notice: "Vous avez une partie en cours !"
      return
    end

    # Remise à zéro du score pour cette playlist et cet utilisateur (seulement si pas de partie terminée)
    # Ne pas supprimer le score si une partie est déjà terminée
    existing_score = Score.find_by(user: current_user, playlist: @playlist)
    existing_score.destroy if existing_score

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
        render :reward_results
      else
        # Calcul de la position dans le classement pour les playlists normales
        scores = Score.where(playlist: @playlist).order(points: :desc)
        user_score_index = scores.pluck(:user_id).index(current_user.id)
        @position = user_score_index ? user_score_index + 1 : scores.count + 1

        # Affiche la vue des résultats normaux
        render :results
      end
    else
      # Continuer le jeu (affichez la vue normale du jeu)
      render :show
    end
  end

  def results
    # Récupérer les informations nécessaires
    @score = Score.find_by(user: current_user, playlist: @game.playlist)
    @playlist = @game.playlist
    
    # Vérifier si c'est une playlist récompense
    if reward_playlist?(@playlist)
      # Pour les playlists récompenses, rediriger vers reward_results
      render :reward_results
      return
    end
    
    # Si pas de score, créer un score basé sur le jeu (seulement pour les playlists normales)
    unless @score
      game_score = @game.score
      @score = Score.create!(
        user: current_user,
        playlist: @playlist,
        points: game_score
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
  end

  def reward_results
    # Méthode spécifique pour les résultats des playlists récompenses
    @playlist = @game.playlist
    
    # Calcul des vidéos likées et non likées
    swipes = @game.swipes.includes(:video)
    @liked_videos = swipes.where(action: "like").map(&:video)
    @not_liked_videos = @playlist.videos - @liked_videos
  end

  def swipe
    # Empêcher de swiper si le jeu est déjà terminé
    if @game.completed?
      redirect_to results_playlist_game_path(@game.playlist, @game), alert: "Cette partie est déjà terminée !"
      return
    end

    Rails.logger.info "Params reçus : #{params.inspect}"

    video = @game.current_video
    action = params[:direction] == "like" ? "like" : "dislike"
    liked_value = (action == "like")

    Rails.logger.info "Vidéo actuelle : #{video&.title} | Utilisateur : #{current_user&.id} | Action : #{action}"

    # Créer le swipe
    swipe = @game.swipes.create!(
      user: current_user,
      video: video,
      action: action,
      liked: liked_value,
      playlist: @playlist
    )

    # Pour les playlists récompenses, pas de système de points
    # Pour les playlists normales, calculer et sauvegarder les points
    unless reward_playlist?(@playlist)
      # Calcul des points en fonction de l'action (seulement pour les playlists normales)
      points = action == "like" ? 2 : 1

      # Mettre à jour ou créer le score (seulement pour cette partie)
      score = Score.find_or_initialize_by(user: current_user, playlist: @playlist)
      
      # Calculer le score total de cette partie seulement
      game_score = @game.swipes.where(action: 'like').count * 2 + @game.swipes.where(action: 'dislike').count
      score.points = game_score
      score.save!
    end

    @game.reload

    next_video = @game.next_video
    Rails.logger.info "Vidéo suivante : #{next_video&.title}"

    # Marquer le jeu comme terminé s'il n'y a plus de vidéos
    if !next_video && @game.completed?
      @game.update(completed_at: Time.current)
    end

    if next_video
      redirect_to playlist_game_path(@game.playlist, @game), notice: "Vidéo #{action} enregistrée !"
    else
      if reward_playlist?(@playlist)
        redirect_to results_playlist_game_path(@game.playlist, @game), notice: "Félicitations ! Vous avez terminé la playlist récompense !"
      else
        redirect_to results_playlist_game_path(@game.playlist, @game), notice: "Félicitations ! Vous avez terminé la playlist !"
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
    
    # Pour les playlists normales, vérifier si déjà terminée
    completed_game = current_user.games.where(playlist: @playlist).where.not(completed_at: nil).last
    
    if completed_game
      redirect_to results_playlist_game_path(@playlist, completed_game), alert: "Vous avez déjà terminé cette playlist !"
      return
    end
    
    # Vérifier l'accès premium avant de créer le jeu
    if @playlist.premium?
      unless UserPlaylistUnlock.exists?(user: current_user, playlist: @playlist) || current_user.total_points >= 500
        redirect_to playlists_path, alert: "Vous avez besoin d'au moins 500 points pour accéder à cette playlist premium."
        return
      end
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
    # Vérifier si la playlist est premium et si l'utilisateur a accès
    if @playlist.premium?
      # Vérifier si l'utilisateur a débloqué cette playlist ou s'il a suffisamment de points
      unless UserPlaylistUnlock.exists?(user: current_user, playlist: @playlist) || current_user.total_points >= 500
        redirect_to playlists_path, alert: "Vous avez besoin d'au moins 500 points pour accéder à cette playlist premium."
      end
    end
  end

  def reward_playlist?(playlist)
    # Définir ici les playlists récompenses
    # Vérifier si le titre contient "reward", "récompense" ou "challenge"
    title = playlist.title.downcase
    title.include?("reward") || title.include?("récompense") || title.include?("challenge")
  end
end
