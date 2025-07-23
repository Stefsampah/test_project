class Badge < ApplicationRecord
  BADGE_TYPES = %w[competitor engager critic challenger].freeze
  LEVELS = %w[bronze silver gold].freeze
  REWARD_TYPES = %w[standard premium].freeze

  validates :name, presence: true
  validates :badge_type, presence: true, inclusion: { in: BADGE_TYPES }
  validates :level, presence: true, inclusion: { in: LEVELS }
  validates :points_required, presence: true, numericality: { greater_than: 0 }
  validates :reward_type, inclusion: { in: REWARD_TYPES }, allow_nil: true
  validates :badge_type, uniqueness: { scope: :level }
  validates :reward_description, presence: true, if: -> { reward_type.present? }
  
  # Nouvelles validations pour les conditions multiples
  validates :condition_1_type, inclusion: { in: %w[points_earned games_played win_ratio top_3_count consecutive_wins unique_playlists genres_explored completed_playlists performance_diversity] }, allow_nil: true
  validates :condition_2_type, inclusion: { in: %w[points_earned games_played win_ratio top_3_count consecutive_wins unique_playlists genres_explored completed_playlists performance_diversity] }, allow_nil: true
  validates :condition_3_type, inclusion: { in: %w[points_earned games_played win_ratio top_3_count consecutive_wins unique_playlists genres_explored completed_playlists performance_diversity] }, allow_nil: true

  has_many :user_badges
  has_many :users, through: :user_badges
  has_many :badge_playlist_unlocks
  has_many :exclusive_playlists, through: :badge_playlist_unlocks, source: :playlist

  def self.competitor_badges
    where(badge_type: 'competitor').order(points_required: :asc)
  end

  def self.engager_badges
    where(badge_type: 'engager').order(points_required: :asc)
  end

  def self.critic_badges
    where(badge_type: 'critic').order(points_required: :asc)
  end

  def self.challenger_badges
    where(badge_type: 'challenger').order(points_required: :asc)
  end

  def next_level
    return nil if level == 'gold'
    
    current_index = LEVELS.index(level)
    next_level_name = LEVELS[current_index + 1]
    self.class.find_by(badge_type: badge_type, level: next_level_name)
  end

  def previous_level
    return nil if level == 'bronze'
    
    current_index = LEVELS.index(level)
    previous_level_name = LEVELS[current_index - 1]
    self.class.find_by(badge_type: badge_type, level: previous_level_name)
  end

  def image_path
    if image.present?
      "/assets/badges/#{image}"
    else
      # Image par défaut basée sur le type et le niveau
      "/assets/badges/default-#{badge_type}-#{level}.png"
    end
  end

  # Méthodes pour vérifier les conditions multiples
  def conditions_met?(user)
    return true if condition_1_type.blank? # Fallback vers l'ancien système
    
    conditions = []
    conditions << check_condition(user, condition_1_type, condition_1_value) if condition_1_type.present?
    conditions << check_condition(user, condition_2_type, condition_2_value) if condition_2_type.present?
    conditions << check_condition(user, condition_3_type, condition_3_value) if condition_3_type.present?
    
    conditions.all?
  end

  def check_condition(user, condition_type, required_value)
    return false if required_value.blank?
    
    actual_value = case condition_type
                   when 'points_earned'
                     user.total_points  # Utiliser total_points au lieu de competitor_score
                   when 'games_played'
                     user.games.count
                   when 'win_ratio'
                     user.win_ratio
                   when 'top_3_count'
                     user.top_3_finishes_count
                   when 'consecutive_wins'
                     user.consecutive_wins_count
                   when 'unique_playlists'
                     user.unique_playlists_played_count
                   when 'genres_explored'
                     user.genres_explored_count
                   when 'completed_playlists'
                     user.completed_playlists_count
                   when 'performance_diversity'
                     user.performance_diversity
                   else
                     0
                   end
    
    actual_value >= required_value
  end

  def conditions_description
    conditions = []
    conditions << "#{condition_1_type.humanize}: #{condition_1_value}" if condition_1_type.present?
    conditions << "#{condition_2_type.humanize}: #{condition_2_value}" if condition_2_type.present?
    conditions << "#{condition_3_type.humanize}: #{condition_3_value}" if condition_3_type.present?
    conditions.join(" + ")
  end
end 