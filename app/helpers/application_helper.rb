module ApplicationHelper
  def store_image_path(image_name)
    "/assets/store/#{image_name}"
  end
  
  def get_premium_preview_image
    # Images aléatoires pour les récompenses premium (9 badges)
    # Utiliser l'ID de l'utilisateur pour une sélection cohérente
    user_id = (defined?(current_user) && current_user) ? current_user.id : 1
    premium_images = [
      'https://img.youtube.com/vi/0tJz8JjPbHU/maxresdefault.jpg', # Didi B Félicia
      'https://img.youtube.com/vi/QVvfSQP3JLM/maxresdefault.jpg', # Didi B Bouaké
      'https://img.youtube.com/vi/JWrIfPCyedU/maxresdefault.jpg', # Charles Doré
      'https://img.youtube.com/vi/ICvSOFEKbgs/maxresdefault.jpg', # Miki Accor Arena
      'https://img.youtube.com/vi/ORfP-QudA1A/maxresdefault.jpg', # Timeo
      'https://img.youtube.com/vi/VFvDwn2r5RI/maxresdefault.jpg'  # Marine
    ]
    
    # Sélection basée sur l'ID utilisateur pour la cohérence
    premium_images[user_id % premium_images.length]
  end
  
  def get_ultime_preview_image
    # Images pour les récompenses ultimes (12 badges) - sélection cohérente
    # Utiliser l'ID de l'utilisateur pour une sélection cohérente
    user_id = (defined?(current_user) && current_user) ? current_user.id : 1
    ultime_images = [
      # Backstage réel
      '/assets/rewards/ultime/backstage_real/backstage_concert_1.jpg',
      '/assets/rewards/ultime/backstage_real/backstage_concert_2.jpg',
      '/assets/rewards/ultime/backstage_real/backstage_concert_3.jpg',
      '/assets/rewards/ultime/backstage_real/backstage_concert_4.jpg',
      # Invitation concert
      '/assets/rewards/ultime/concert_invitation/concert_stage_1.jpg',
      '/assets/rewards/ultime/concert_invitation/concert_stage_2.jpg',
      '/assets/rewards/ultime/concert_invitation/concert_stage_3.jpg',
      '/assets/rewards/ultime/concert_invitation/concert_stage_4.jpg',
      # Expérience VIP
      '/assets/rewards/ultime/vip_experience/vip_meeting_1.jpg',
      '/assets/rewards/ultime/vip_experience/vip_meeting_2.jpg',
      '/assets/rewards/ultime/vip_experience/vip_meeting_3.jpg',
      '/assets/rewards/ultime/vip_experience/vip_meeting_4.jpg'
    ]
    
    # Sélection basée sur l'ID utilisateur pour la cohérence
    ultime_images[user_id % ultime_images.length]
  end

  # Retourne la dernière partie en cours de l'utilisateur (non terminée)
  def current_game_in_progress
    return nil unless user_signed_in?
    
    current_user.games.where(completed_at: nil).order(created_at: :desc).first
  end

  # Vérifie si l'utilisateur a une partie en cours
  def has_game_in_progress?
    current_game_in_progress.present?
  end

  # Vérifie si les actions doivent être désactivées (partie en cours non reprise)
  def should_disable_actions?
    return false unless user_signed_in?
    
    # Vérifier si on est sur une page de jeu (dans ce cas, ne pas désactiver)
    is_game_page = request.path.match?(%r{/playlists/\d+/games(/\d+)?(/swipe|/results)?$})
    return false if is_game_page
    
    # Désactiver si une partie est en cours
    has_game_in_progress?
  end
  
  # Helper spécifique pour new_playlist_game_path avec gestion du locale
  def new_playlist_game_path_with_locale(playlist)
    playlist_id = playlist.is_a?(Playlist) ? playlist.id : playlist
    new_playlist_game_path(playlist_id: playlist_id, locale: I18n.locale)
  end

  def playlist_game_path_with_locale(playlist, game)
    playlist_id = playlist.is_a?(Playlist) ? playlist.id : playlist
    game_id = game.is_a?(Game) ? game.id : game
    playlist_game_path(locale: I18n.locale, playlist_id: playlist_id, id: game_id)
  end
end
