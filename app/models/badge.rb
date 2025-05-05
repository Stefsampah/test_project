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

  has_many :user_badges
  has_many :users, through: :user_badges

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
end 