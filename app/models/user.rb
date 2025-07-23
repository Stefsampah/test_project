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
    swipes.where(action: 'like').count * 5 + swipes.where(action: 'dislike').count * 2 || 0
  end

  def critic_score
    # Points pour les critiques : dislikes donnent des points pour l'opinion critique
    swipes.where(action: 'dislike').count * 3 || 0
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
    total_games = games.count
    return 0 if total_games == 0
    
    # Considérer une "victoire" comme un score dans le top 75% de la playlist
    wins = 0
    games.includes(:playlist).each do |game|
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
    count = 0
    games.includes(:playlist).each do |game|
      playlist_scores = Score.where(playlist: game.playlist).order(points: :desc).limit(3)
      user_score = scores.find_by(playlist: game.playlist)&.points || 0
      
      if playlist_scores.any? && user_score >= playlist_scores.last&.points.to_i
        count += 1
      end
    end
    count
  end

  def consecutive_wins_count
    max_consecutive = 0
    current_consecutive = 0
    
    games.includes(:playlist).order(created_at: :asc).each do |game|
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
    games.joins(:playlist).distinct.count(:playlist_id)
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

  private

  def assign_badges
    BadgeService.assign_badges(self)
  end
end
