class Reward < ApplicationRecord
  belongs_to :user
  
  validates :badge_type, presence: true
  validates :quantity_required, presence: true, numericality: { greater_than: 0 }
  validates :reward_type, presence: true
  validates :reward_description, presence: true
  
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
    concert_invitation: 'concert_invitation'
  }
  
  scope :by_badge_type, ->(badge_type) { where(badge_type: badge_type) }
  scope :unlocked, -> { where(unlocked: true) }
  scope :recent, -> { where('created_at >= ?', 30.days.ago) }
  scope :by_reward_type, ->(reward_type) { where(reward_type: reward_type) }
  
  # Système simplifié : récompenses unifiées basées sur le total de badges
  def self.check_and_create_rewards_for_user(user)
    # Vérifier les récompenses unifiées avec système aléatoire
    check_random_rewards(user)
  end
  
  # Système de récompenses aléatoires avec anti-répétition
  def self.check_random_rewards(user)
    badge_count = user.user_badges.count
    
    # Vérifier si l'utilisateur a la collection arc-en-ciel
    has_rainbow = user.has_rainbow_collection?
    
    # Débloquer les récompenses selon le nombre de badges
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
        { content_type: 'playlist_exclusive', name: 'Playlist Exclusive', description: 'Playlist créée par un artiste partenaire', icon: '🎵' },
        { content_type: 'playlist_acoustic', name: 'Playlist Acoustique', description: 'Versions acoustiques des morceaux', icon: '🎤' },
        { content_type: 'playlist_remix', name: 'Remixes Exclusifs', description: 'Playlist de remixes créés spécialement', icon: '🎧' }
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
          { content_type: 'playlist_exclusive', name: 'Playlist Exclusive', description: 'Playlist créée par un artiste partenaire', icon: '🎵' },
          { content_type: 'playlist_acoustic', name: 'Playlist Acoustique', description: 'Versions acoustiques des morceaux', icon: '🎤' },
          { content_type: 'playlist_remix', name: 'Remixes Exclusifs', description: 'Playlist de remixes créés spécialement', icon: '🎧' }
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
    end
    
    # Sélectionner une récompense aléatoire
    selected_reward = available_rewards.sample
    
    # Créer la récompense
    create!(
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
    # Vérifier si la récompense existe déjà
    existing_reward = user.rewards.find_by(
      badge_type: badge_type,
      quantity_required: quantity_required,
      reward_type: reward_type
    )
    
    return if existing_reward&.unlocked?
    
    # Créer ou débloquer la récompense
    reward = user.rewards.find_or_create_by!(
      badge_type: badge_type,
      quantity_required: quantity_required,
      reward_type: reward_type
    ) do |r|
      r.reward_description = generate_reward_description(badge_type, quantity_required, reward_type, category)
      r.unlocked = true
      r.unlocked_at = Time.current
    end
    
    # Si la récompense existait mais n'était pas débloquée, la débloquer
    if reward.persisted? && !reward.unlocked?
      reward.update!(unlocked: true, unlocked_at: Time.current)
    end
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