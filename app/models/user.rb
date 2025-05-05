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

  after_save :assign_badges

  def competitor_score
    scores.sum(:points) || 0
  end

  def engager_score
    swipes.count * 10 || 0
  end

  def critic_score
    swipes.where(action: 'dislike').count * 5 || 0
  end

  def challenger_score
    (competitor_score + engager_score + critic_score) / 3 || 0
  end

  def earned_badges
    user_badges.includes(:badge).where.not(earned_at: nil)
  end

  def available_rewards
    user_badges.includes(:badge).where(claimed_at: nil).where.not(earned_at: nil)
  end

  def claim_reward!(user_badge_id)
    user_badge = user_badges.find(user_badge_id)
    user_badge.claim_reward! if user_badge.reward_available?
  end

  private

  def assign_badges
    BadgeService.assign_badges(self)
  end
end
