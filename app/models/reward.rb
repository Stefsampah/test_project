class Reward < ApplicationRecord
  belongs_to :user
  
  validates :badge_type, presence: true
  validates :quantity_required, presence: true, numericality: { greater_than: 0 }
  validates :reward_type, presence: true
  validates :reward_description, presence: true
  validates :content_type, presence: true # Nouvelle validation pour content_type obligatoire
  
  enum reward_type: {
    challenge: 'challenge',
    exclusif: 'exclusif', 
    premium: 'premium',
    ultime: 'ultime'
  }
  
  # Types de contenu pour les récompenses digitales
  enum content_type: {
    playlist_exclusive: 'playlist_exclusive',
    playlist_acoustic: 'playlist_acoustic',
    playlist_remix: 'playlist_remix',
    podcast_exclusive: 'podcast_exclusive',
    blog_article: 'blog_article',
    documentary: 'documentary',
    reportage: 'reportage',
    audio_comments: 'audio_comments',
    studio_session: 'studio_session',
    exclusive_photos: 'exclusive_photos',
    backstage_video: 'backstage_video',
    concert_footage: 'concert_footage',
    personal_voice_message: 'personal_voice_message',
    dedicated_photo: 'dedicated_photo',
    concert_invitation: 'concert_invitation',
    challenge_reward_playlist_1: 'challenge_reward_playlist_1',
    challenge_reward_playlist_2: 'challenge_reward_playlist_2',
    challenge_reward_playlist_3: 'challenge_reward_playlist_3',
    challenge_reward_playlist_4: 'challenge_reward_playlist_4',
    challenge_reward_playlist_5: 'challenge_reward_playlist_5',
    challenge_reward_playlist_6: 'challenge_reward_playlist_6',
    challenge_reward_playlist_7: 'challenge_reward_playlist_7',
    challenge_reward_playlist_8: 'challenge_reward_playlist_8',
    challenge_reward_playlist_9: 'challenge_reward_playlist_9',
    challenge_reward_playlist_10: 'challenge_reward_playlist_10',
    challenge_reward_playlist_11: 'challenge_reward_playlist_11',
    challenge_reward_playlist_12: 'challenge_reward_playlist_12',
    challenge_reward_playlist_13: 'challenge_reward_playlist_13',
    challenge_reward_playlist_14: 'challenge_reward_playlist_14',
    challenge_reward_playlist_15: 'challenge_reward_playlist_15'
  }
  
  scope :by_badge_type, ->(badge_type) { where(badge_type: badge_type) }
  scope :unlocked, -> { where(unlocked: true) }
  scope :recent, -> { where('created_at >= ?', 30.days.ago) }
  scope :by_reward_type, ->(reward_type) { where(reward_type: reward_type) }
  
  # Système unifié : récompenses basées sur le total de badges avec content_type obligatoire
  def self.check_and_create_rewards_for_user(user)
    # Vérifier les récompenses unifiées avec système aléatoire
    check_random_rewards(user)
  end
  
  # Système de récompenses aléatoires avec anti-répétition
  def self.check_random_rewards(user)
    badge_count = user.user_badges.count
    
    # Vérifier si l'utilisateur a la collection arc-en-ciel
    has_rainbow = user.has_rainbow_collection?
    
    # Débloquer les récompenses selon le nombre de badges (une seule par niveau)
    if badge_count >= 3 && !user.rewards.challenge.exists?
      select_random_reward(user, 'challenge')
    end
    
    if badge_count >= 6 && !user.rewards.exclusif.exists?
      select_random_reward(user, 'exclusif')
    end
    
    if badge_count >= 9 && !user.rewards.premium.exists?
      select_random_reward(user, 'premium')
    end
    
    if has_rainbow && !user.rewards.ultime.exists?
      select_random_reward(user, 'ultime')
    end
  end
  
  # Sélection aléatoire avec anti-répétition
  def self.select_random_reward(user, level)
    # Récupérer les récompenses récentes de l'utilisateur pour éviter les doublons
    recent_rewards = user.rewards.recent.pluck(:content_type).compact
    
    # Définir les récompenses disponibles par niveau
    available_rewards = case level
    when 'challenge'
      [
        { content_type: 'challenge_reward_playlist_1', name: 'Challenge Reward Playlist 1', description: 'Playlist exclusive débloquée via les récompenses challenge', icon: '🏆' },
        { content_type: 'challenge_reward_playlist_2', name: 'Challenge Reward Playlist 2', description: 'Deuxième playlist exclusive débloquée via les récompenses challenge', icon: '🏆' },
        { content_type: 'challenge_reward_playlist_3', name: 'Challenge Reward Playlist 3', description: 'Troisième playlist exclusive débloquée via les récompenses challenge', icon: '🏆' },
        { content_type: 'challenge_reward_playlist_4', name: 'Challenge Reward Playlist 4', description: 'Quatrième playlist exclusive débloquée via les récompenses challenge', icon: '🏆' },
        { content_type: 'challenge_reward_playlist_5', name: 'Challenge Reward Playlist 5', description: 'Cinquième playlist exclusive débloquée via les récompenses challenge', icon: '🏆' },
        { content_type: 'challenge_reward_playlist_6', name: 'Challenge Reward Playlist Alternative 6', description: 'Sixième playlist exclusive débloquée via les récompenses challenge - Versions alternatives', icon: '🎤' },
        { content_type: 'challenge_reward_playlist_7', name: 'Challenge Reward Playlist Alternative 7', description: 'Septième playlist exclusive débloquée via les récompenses challenge - Versions alternatives', icon: '🎤' },
        { content_type: 'challenge_reward_playlist_8', name: 'Challenge Reward Playlist Alternative 8', description: 'Huitième playlist exclusive débloquée via les récompenses challenge - Versions alternatives', icon: '🎧' },
        { content_type: 'challenge_reward_playlist_9', name: 'Challenge Reward Playlist Alternative 9', description: 'Neuvième playlist exclusive débloquée via les récompenses challenge - Versions alternatives', icon: '🎧' },
        { content_type: 'challenge_reward_playlist_10', name: 'Challenge Reward Videos 10', description: 'Playlist exclusive de 10 titres hip-hop et R&B débloquée via les récompenses challenge', icon: '🎵' },
        { content_type: 'challenge_reward_playlist_11', name: 'Challenge Reward Videos 11', description: 'Playlist exclusive de remixes débloquée via les récompenses challenge', icon: '🎛️' },
        { content_type: 'challenge_reward_playlist_12', name: 'Challenge Reward Videos 12', description: 'Playlist exclusive de versions alternatives débloquée via les récompenses challenge', icon: '🎵' },
        { content_type: 'challenge_reward_playlist_13', name: 'Challenge Reward Videos 13', description: 'Playlist exclusive de versions live débloquée via les récompenses challenge', icon: '🎤' },
        { content_type: 'challenge_reward_playlist_14', name: 'Challenge Reward Videos 14', description: 'Playlist exclusive de versions instrumentales débloquée via les récompenses challenge', icon: '🎧' },
        { content_type: 'challenge_reward_playlist_15', name: 'Challenge Reward Videos 15', description: 'Playlist exclusive de versions exclusives débloquée via les récompenses challenge', icon: '⭐' }
      ]
    when 'exclusif'
      [
        { content_type: 'podcast_exclusive', name: 'Podcast Exclusif', description: 'Interview exclusive d\'un artiste', icon: '🎙️' },
        { content_type: 'blog_article', name: 'Article Blog', description: 'Article spécialisé sur la musique', icon: '📝' },
        { content_type: 'documentary', name: 'Documentaire', description: 'Documentaire musical exclusif', icon: '🎬' },
        { content_type: 'reportage', name: 'Reportage', description: 'Reportage exclusif sur un artiste', icon: '📺' },
        { content_type: 'audio_comments', name: 'Commentaires Audio', description: 'Artistes commentent leurs chansons', icon: '🎧' },
        { content_type: 'studio_session', name: 'Session Studio', description: 'Vidéo d\'enregistrement en studio', icon: '🎹' }
      ]
    when 'premium'
      [
        { content_type: 'exclusive_photos', name: 'Photos Exclusives', description: 'Photos exclusives d\'artistes', icon: '📸' },
        { content_type: 'backstage_video', name: 'Vidéo Backstage', description: 'Vidéo backstage exclusive', icon: '🎭' },
        { content_type: 'concert_footage', name: 'Extrait Concert', description: 'Extrait exclusif d\'un concert', icon: '🎪' }
      ]
    when 'ultime'
      [
        { content_type: 'personal_voice_message', name: 'Message Vocal Personnalisé', description: 'Message vocal d\'un artiste pour vous', icon: '🎤' },
        { content_type: 'dedicated_photo', name: 'Photo Dédicacée', description: 'Photo dédicacée d\'un artiste', icon: '📷' },
        { content_type: 'concert_invitation', name: 'Invitation Concert', description: 'Invitation à un concert près de chez vous', icon: '🎫' }
      ]
    end
    
    # Filtrer les récompenses déjà obtenues récemment
    available_rewards = available_rewards.reject { |reward| recent_rewards.include?(reward[:content_type]) }
    
    # Si toutes les récompenses ont été obtenues récemment, réinitialiser
    if available_rewards.empty?
      available_rewards = case level
      when 'challenge'
        [
          { content_type: 'challenge_reward_playlist_1', name: 'Challenge Reward Playlist 1', description: 'Playlist exclusive débloquée via les récompenses challenge', icon: '🏆' },
          { content_type: 'challenge_reward_playlist_2', name: 'Challenge Reward Playlist 2', description: 'Deuxième playlist exclusive débloquée via les récompenses challenge', icon: '🏆' },
          { content_type: 'challenge_reward_playlist_3', name: 'Challenge Reward Playlist 3', description: 'Troisième playlist exclusive débloquée via les récompenses challenge', icon: '🏆' },
          { content_type: 'challenge_reward_playlist_4', name: 'Challenge Reward Playlist 4', description: 'Quatrième playlist exclusive débloquée via les récompenses challenge', icon: '🏆' },
          { content_type: 'challenge_reward_playlist_5', name: 'Challenge Reward Playlist 5', description: 'Cinquième playlist exclusive débloquée via les récompenses challenge', icon: '🏆' }
        ]
      when 'exclusif'
        [
          { content_type: 'podcast_exclusive', name: 'Podcast Exclusif', description: 'Interview exclusive d\'un artiste', icon: '🎙️' },
          { content_type: 'blog_article', name: 'Article Blog', description: 'Article spécialisé sur la musique', icon: '📝' },
          { content_type: 'documentary', name: 'Documentaire', description: 'Documentaire musical exclusif', icon: '🎬' }
        ]
      when 'premium'
        [
          { content_type: 'exclusive_photos', name: 'Photos Exclusives', description: 'Photos exclusives d\'artistes', icon: '📸' },
          { content_type: 'backstage_video', name: 'Vidéo Backstage', description: 'Vidéo backstage exclusive', icon: '🎭' }
        ]
      when 'ultime'
        [
          { content_type: 'personal_voice_message', name: 'Message Vocal Personnalisé', description: 'Message vocal d\'un artiste pour vous', icon: '🎤' },
          { content_type: 'dedicated_photo', name: 'Photo Dédicacée', description: 'Photo dédicacée d\'un artiste', icon: '📷' }
        ]
      end
    end
    
    # Sélectionner une récompense aléatoire
    selected_reward = available_rewards.sample
    
    # Créer la récompense avec content_type obligatoire
    reward = create!(
      user: user,
      reward_type: level,
      content_type: selected_reward[:content_type],
      reward_description: selected_reward[:description],
      quantity_required: case level
                        when 'challenge' then 3
                        when 'exclusif' then 6
                        when 'premium' then 9
                        when 'ultime' then 12
                        end,
      badge_type: 'unified',
      unlocked: true,
      unlocked_at: Time.current
    )
    
    # Débloquer automatiquement les playlists challenge si nécessaire
    unlock_challenge_playlists(user, selected_reward[:content_type]) if level == 'challenge'
    
    reward
  end
  
  # Débloquer les playlists challenge selon la récompense obtenue
  def self.unlock_challenge_playlists(user, content_type)
    case content_type
    when 'challenge_reward_playlist_1'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🏆 Challenge Reward Playlist 1 débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_2'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🏆 Challenge Reward Playlist 2 débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_3'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🏆 Challenge Reward Playlist 3 débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_4'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🏆 Challenge Reward Playlist 4 débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_5'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🏆 Challenge Reward Playlist 5 débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_6'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🎤 Challenge Reward Playlist Alternative 6 débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_7'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🎤 Challenge Reward Playlist Alternative 7 débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_8'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🎧 Challenge Reward Playlist Alternative 8 débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_9'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🎧 Challenge Reward Playlist Alternative 9 débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_10'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🎵 Challenge Reward Videos 10 débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_11'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🎛️ Challenge Reward Videos 11 (Remixes) débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_12'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🎵 Challenge Reward Videos 12 (Versions alternatives) débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_13'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🎤 Challenge Reward Videos 13 (Versions live) débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_14'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🎧 Challenge Reward Videos 14 (Versions instrumentales) débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_15'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "⭐ Challenge Reward Videos 15 (Versions exclusives) débloquée comme récompense pour #{user.email}"
    end
  end
  
  # Récupérer les playlists challenge débloquées par un utilisateur
  def self.challenge_playlists_for_user(user)
    challenge_rewards = user.rewards.where(content_type: ['challenge_reward_playlist_1', 'challenge_reward_playlist_2', 'challenge_reward_playlist_3', 'challenge_reward_playlist_4', 'challenge_reward_playlist_5', 'challenge_reward_playlist_6', 'challenge_reward_playlist_7', 'challenge_reward_playlist_8', 'challenge_reward_playlist_9', 'challenge_reward_playlist_10', 'challenge_reward_playlist_11', 'challenge_reward_playlist_12', 'challenge_reward_playlist_13', 'challenge_reward_playlist_14', 'challenge_reward_playlist_15'])
    
    playlists = []
    challenge_rewards.each do |reward|
      case reward.content_type
      when 'challenge_reward_playlist_1'
        playlist = Playlist.find_by(title: 'Challenge Reward Playlist 1')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_2'
        playlist = Playlist.find_by(title: 'Challenge Reward Playlist 2')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_3'
        playlist = Playlist.find_by(title: 'Challenge Reward Playlist 3')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_4'
        playlist = Playlist.find_by(title: 'Challenge Reward Playlist 4')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_5'
        playlist = Playlist.find_by(title: 'Challenge Reward Playlist 5')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_6'
        playlist = Playlist.find_by(title: 'Challenge Reward Playlist Alternative 6')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_7'
        playlist = Playlist.find_by(title: 'Challenge Reward Playlist Alternative 7')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_8'
        playlist = Playlist.find_by(title: 'Challenge Reward Playlist Alternative 8')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_9'
        playlist = Playlist.find_by(title: 'Challenge Reward Playlist Alternative 9')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_10'
        playlist = Playlist.find_by(title: 'Challenge Reward Videos 10')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_11'
        playlist = Playlist.find_by(title: 'Challenge Reward Videos 11')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_12'
        playlist = Playlist.find_by(title: 'Challenge Reward Videos 12')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_13'
        playlist = Playlist.find_by(title: 'Challenge Reward Videos 13')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_14'
        playlist = Playlist.find_by(title: 'Challenge Reward Videos 14')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_15'
        playlist = Playlist.find_by(title: 'Challenge Reward Videos 15')
        playlists << playlist if playlist
      end
    end
    
    playlists
  end
  
  # Récompenses unifiées basées sur le total de badges
  def self.check_unified_rewards(user)
    total_badges = user.user_badges.count
    
    # Récompenses unifiées : 3, 6, 9, 12 badges
    [3, 6, 9, 12].each do |required_count|
      next if total_badges < required_count
      
      reward_type = case required_count
                   when 3 then 'challenge'
                   when 6 then 'exclusif'
                   when 9 then 'premium'
                   when 12 then 'ultime'
                   end
      
      check_reward_condition(user, 'unified', required_count, reward_type, "unified")
    end
  end
  
  # Méthode pour vérifier si une récompense peut être débloquée
  def can_be_unlocked?(user)
    case reward_category
    when 'unified'
      total_badges = user.user_badges.count
      total_badges >= quantity_required
    else
      false
    end
  end
  
  # Méthode pour obtenir la progression actuelle
  def current_progress(user)
    case reward_category
    when 'unified'
      user.user_badges.count
    else
      0
    end
  end
  
  # Méthode pour obtenir le pourcentage de progression
  def progress_percentage(user)
    current = current_progress(user)
    [(current.to_f / quantity_required * 100), 100].min
  end
  
  # Méthode pour obtenir le prochain niveau de récompense
  def self.next_reward_level(user, category)
    case category
    when 'unified'
      total_badges = user.user_badges.count
      case total_badges
      when 0..2 then { level: 'challenge', required: 3, current: total_badges, remaining: 3 - total_badges }
      when 3..5 then { level: 'exclusif', required: 6, current: total_badges, remaining: 6 - total_badges }
      when 6..8 then { level: 'premium', required: 9, current: total_badges, remaining: 9 - total_badges }
      when 9..11 then { level: 'ultime', required: 12, current: total_badges, remaining: 12 - total_badges }
      else { level: 'max', required: 12, current: total_badges, remaining: 0 }
      end
    end
  end
  
  private
  
  def reward_category
    # Catégorie unifiée pour toutes les récompenses
    'unified'
  end
  
  # Obtenir l'icône de la récompense
  def icon
    case content_type
    when 'playlist_exclusive', 'playlist_acoustic', 'playlist_remix'
      '🎵'
    when 'podcast_exclusive'
      '🎙️'
    when 'blog_article'
      '📝'
    when 'documentary'
      '🎬'
    when 'reportage'
      '📺'
    when 'audio_comments'
      '🎧'
    when 'studio_session'
      '🎹'
    when 'exclusive_photos', 'dedicated_photo'
      '📸'
    when 'backstage_video'
      '🎭'
    when 'concert_footage', 'concert_invitation'
      '🎪'
    when 'personal_voice_message'
      '🎤'
    when 'challenge_reward_playlist_1', 'challenge_reward_playlist_2'
      '🏆'
    else
      '🎁'
    end
  end
  
  # Obtenir la couleur de la récompense selon le niveau
  def color
    case reward_type
    when 'challenge'
      '#FFD700' # Or
    when 'exclusif'
      '#C0C0C0' # Argent
    when 'premium'
      '#CD7F32' # Bronze
    when 'ultime'
      '#FF69B4' # Rose vif
    else
      '#808080' # Gris
    end
  end
  
  def self.check_reward_condition(user, badge_type, quantity_required, reward_type, category)
    # Vérifier si la récompense existe déjà (par reward_type uniquement)
    existing_reward = user.rewards.find_by(reward_type: reward_type)
    
    return if existing_reward&.unlocked?
    
    # Si une récompense existe mais n'est pas débloquée, la débloquer
    if existing_reward && !existing_reward.unlocked?
      existing_reward.update!(unlocked: true, unlocked_at: Time.current)
      return existing_reward
    end
    
    # Créer une nouvelle récompense avec content_type obligatoire
    reward_data = select_random_reward_data(reward_type)
    
    reward = user.rewards.create!(
      badge_type: badge_type,
      quantity_required: quantity_required,
      reward_type: reward_type,
      content_type: reward_data[:content_type],
      reward_description: reward_data[:description],
      unlocked: true,
      unlocked_at: Time.current
    )
    
    reward
  end
  
  # Nouvelle méthode pour sélectionner les données de récompense
  def self.select_random_reward_data(reward_type)
    case reward_type
    when 'challenge'
      available_rewards = [
        { content_type: 'challenge_reward_playlist_1', description: 'Playlist exclusive débloquée via les récompenses challenge' },
        { content_type: 'challenge_reward_playlist_2', description: 'Deuxième playlist exclusive débloquée via les récompenses challenge' },
        { content_type: 'challenge_reward_playlist_3', description: 'Troisième playlist exclusive débloquée via les récompenses challenge' },
        { content_type: 'challenge_reward_playlist_4', description: 'Quatrième playlist exclusive débloquée via les récompenses challenge' },
        { content_type: 'challenge_reward_playlist_5', description: 'Cinquième playlist exclusive débloquée via les récompenses challenge' }
      ]
    when 'exclusif'
      available_rewards = [
        { content_type: 'podcast_exclusive', description: 'Interview exclusive d\'un artiste' },
        { content_type: 'blog_article', description: 'Article spécialisé sur la musique' },
        { content_type: 'documentary', description: 'Documentaire musical exclusif' }
      ]
    when 'premium'
      available_rewards = [
        { content_type: 'exclusive_photos', description: 'Photos exclusives d\'artistes' },
        { content_type: 'backstage_video', description: 'Vidéo backstage exclusive' }
      ]
    when 'ultime'
      available_rewards = [
        { content_type: 'personal_voice_message', description: 'Message vocal d\'un artiste pour vous' },
        { content_type: 'dedicated_photo', description: 'Photo dédicacée d\'un artiste' }
      ]
    else
      available_rewards = [
        { content_type: 'playlist_exclusive', description: 'Playlist exclusive' }
      ]
    end
    
    available_rewards.sample
  end
  
  def self.generate_reward_description(badge_type, quantity, reward_type, category)
    case reward_type
    when 'challenge'
      "#{quantity} badges - Accès anticipé et codes promo débloqués"
    when 'exclusif'
      "#{quantity} badges - Photos dédicacées et contenu exclusif débloqués"
    when 'premium'
      "#{quantity} badges - Rencontres artistes et backstage virtuel débloqués"
    when 'ultime'
      "#{quantity} badges - Rencontre privée et backstage réel débloqués"
    end
  end
end 