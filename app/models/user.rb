class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :games
  has_many :swipes
  has_many :scores
  has_many :videos, through: :swipes
  has_many :playlists, through: :swipes
  has_one_attached :avatar

  has_many :user_badges
  has_many :badges, through: :user_badges

  has_many :user_playlist_unlocks
  has_many :unlocked_playlists, through: :user_playlist_unlocks, source: :playlist
  
  has_many :rewards
  has_many :digital_rewards

  after_save :assign_badges
  after_create :assign_badges
  
  # Callbacks pour attribuer les badges après modification des scores
  # Note: Ces callbacks sont désactivés car les associations n'ont pas de compteurs automatiques
  # Les badges sont assignés via BadgeService.assign_badges(user) après chaque action

  def competitor_score
    scores.sum(:points) || 0
  end

  def engager_score
    # Points pour l'engagement : likes donnent plus de points que dislikes
    # Exclure les playlists récompenses du calcul
    swipes.joins(:playlist)
          .where.not(playlists: { id: reward_playlist_ids })
          .where(action: 'like').count * 5 + 
    swipes.joins(:playlist)
          .where.not(playlists: { id: reward_playlist_ids })
          .where(action: 'dislike').count * 2 || 0
  end

  def critic_score
    # Points pour les critiques : dislikes donnent des points pour l'opinion critique
    # Exclure les playlists récompenses du calcul
    swipes.joins(:playlist)
          .where.not(playlists: { id: reward_playlist_ids })
          .where(action: 'dislike').count * 3 || 0
  end

  def challenger_score
    # Score basé sur la performance globale (pas une moyenne)
    (competitor_score + engager_score + critic_score) || 0
  end

  def total_points
    # Inclure les points achetés dans la boutique
    purchased_points = self.points || 0
    # challenger_score est déjà la somme des autres scores, éviter la double comptabilisation
    game_points = challenger_score
    purchased_points + game_points
  end

  # Nouvelles méthodes pour les conditions multiples
  def win_ratio
    # Exclure les playlists récompenses du calcul
    total_games = games.joins(:playlist).where.not(playlists: { id: reward_playlist_ids }).count
    return 0 if total_games == 0
    
    # Considérer une "victoire" comme un score dans le top 75% de la playlist
    wins = 0
    games.includes(:playlist).where.not(playlists: { id: reward_playlist_ids }).each do |game|
      playlist_scores = Score.where(playlist: game.playlist).order(points: :desc)
      user_score = scores.find_by(playlist: game.playlist)&.points || 0
      
      if playlist_scores.count > 0
        # Top 75% au lieu de 50% (médiane)
        top_75_threshold = playlist_scores.offset((playlist_scores.count * 0.25).to_i).first&.points || 0
        wins += 1 if user_score >= top_75_threshold
      end
    end
    
    (wins.to_f / total_games * 100).round(1)
  end

  def top_3_finishes_count
    # Exclure les playlists récompenses du calcul
    count = 0
    games.includes(:playlist).where.not(playlists: { id: reward_playlist_ids }).each do |game|
      playlist_scores = Score.where(playlist: game.playlist).order(points: :desc).limit(3)
      user_score = scores.find_by(playlist: game.playlist)&.points || 0
      
      if playlist_scores.any? && user_score >= playlist_scores.last&.points.to_i
        count += 1
      end
    end
    count
  end

  def consecutive_wins_count
    # Exclure les playlists récompenses du calcul
    max_consecutive = 0
    current_consecutive = 0
    
    games.includes(:playlist).where.not(playlists: { id: reward_playlist_ids }).order(created_at: :asc).each do |game|
      playlist_scores = Score.where(playlist: game.playlist).order(points: :desc)
      user_score = scores.find_by(playlist: game.playlist)&.points || 0
      
      if playlist_scores.count > 0
        median_score = playlist_scores.offset(playlist_scores.count / 2).first&.points || 0
        
        if user_score >= median_score
          current_consecutive += 1
          max_consecutive = [max_consecutive, current_consecutive].max
        else
          current_consecutive = 0
        end
      end
    end
    
    max_consecutive
  end

  def unique_playlists_played_count
    # Exclure les playlists récompenses du calcul
    games.joins(:playlist).where.not(playlists: { id: reward_playlist_ids }).distinct.count(:playlist_id)
  end

  def genres_explored_count
    # Exclure les playlists récompenses du calcul
    games.joins(:playlist).where.not(playlists: { id: reward_playlist_ids }).where.not(playlists: { genre: [nil, ''] }).distinct.count('playlists.genre')
  end

  def completed_playlists_count
    # Exclure les playlists récompenses du calcul
    games.joins(:playlist).where.not(playlists: { id: reward_playlist_ids }).where.not(completed_at: nil).distinct.count(:playlist_id)
  end

  def performance_diversity
    # Nombre de playlists où l'utilisateur a un score > moyenne de ses scores
    user_average = scores.average(:points) || 0
    scores.where('points > ?', user_average).distinct.count(:playlist_id)
  end

  def earned_badges
    user_badges.includes(:badge).where.not(earned_at: nil)
  end

  def available_rewards
    # Tous les badges gagnés ont leurs récompenses automatiquement disponibles
    user_badges.includes(:badge).where.not(earned_at: nil)
  end

  # Méthode de classe pour vérifier et corriger les badges de tous les utilisateurs
  def self.check_and_fix_all_badges
    User.all.each do |user|
      BadgeService.assign_badges(user)
    end
  end

  # Vérifier si l'utilisateur peut obtenir un badge spécifique
  def can_earn_badge?(badge)
    # Vérifier d'abord les conditions multiples si elles existent
    return false unless badge.conditions_met?(self)
    
    # Utiliser total_points pour inclure les points achetés
    current_score = total_points
    
    current_score >= badge.points_required && !badges.include?(badge)
  end

  # Obtenir tous les badges que l'utilisateur peut obtenir
  def obtainable_badges
    Badge.all.select { |badge| can_earn_badge?(badge) }
  end

  # Obtenir le prochain badge à obtenir pour chaque type
  def next_badges
    next_badges = {}
    
    Badge::BADGE_TYPES.each do |badge_type|
      # Utiliser total_points pour inclure les points achetés
      current_score = total_points
      
      next_badge = Badge.where(badge_type: badge_type)
                       .where('points_required > ?', current_score)
                       .order(:points_required)
                       .first
      
      next_badges[badge_type] = {
        badge: next_badge,
        current_score: current_score,
        points_needed: next_badge ? next_badge.points_required - current_score : 0
      }
    end
    
    next_badges
  end

  # Méthodes pour les récompenses digitales
  def has_rainbow_collection?
    # Vérifier si l'utilisateur a au moins 1 badge de chaque niveau
    bronze_count = user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    silver_count = user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    gold_count = user_badges.joins(:badge).where(badges: { level: 'gold' }).count
    
    bronze_count >= 1 && silver_count >= 1 && gold_count >= 1
  end
  
  def digital_rewards_by_level(level)
    digital_rewards.where(reward_level: level)
  end
  
  def has_digital_reward_for_level?(level)
    digital_rewards.where(reward_level: level).exists?
  end
  
  def next_digital_reward_level
    badge_count = user_badges.count
    
    # Vérifier si toutes les récompenses sont débloquées
    if has_reward_for_level?('challenge') && has_reward_for_level?('exclusif') && 
       has_reward_for_level?('premium') && has_reward_for_level?('ultime')
      'completed'
    elsif badge_count >= 12 && !has_reward_for_level?('ultime')
      'ultime'
    elsif badge_count >= 9 && !has_reward_for_level?('premium')
      'premium'
    elsif badge_count >= 6 && !has_reward_for_level?('exclusif')
      'exclusif'
    elsif badge_count >= 3 && !has_reward_for_level?('challenge')
      'challenge'
    else
      nil
    end
  end
  
  def progress_to_next_digital_reward
    badge_count = user_badges.count
    
    case next_digital_reward_level
    when 'challenge'
      [badge_count, 3]
    when 'exclusif'
      [badge_count, 6]
    when 'premium'
      [badge_count, 9]
    else
      [badge_count, 3]
    end
  end
  
  # Méthodes pour les récompenses (intégrées dans le système existant)
  def rewards_by_level(level)
    rewards.where(reward_type: level)
  end
  
  def has_reward_for_level?(level)
    rewards.where(reward_type: level).exists?
  end

  # Récupérer les playlists challenge débloquées via les récompenses
  def challenge_playlists
    Reward.challenge_playlists_for_user(self)
  end
  
  # Vérifier si l'utilisateur a une récompense challenge spécifique
  def has_challenge_reward?(content_type)
    rewards.exists?(content_type: content_type)
  end

  private

  def reward_playlist_ids
    @reward_playlist_ids ||= Playlist.where("LOWER(title) LIKE ? OR LOWER(title) LIKE ? OR LOWER(title) LIKE ?", 
                                           "%reward%", "%récompense%", "%challenge%").pluck(:id)
  end

  def assign_badges
    BadgeService.assign_badges(self)
    # Vérifier et débloquer les récompenses digitales après attribution des badges
    Reward.check_and_create_rewards_for_user(self)
  end
end
