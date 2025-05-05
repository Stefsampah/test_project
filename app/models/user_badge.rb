class UserBadge < ApplicationRecord
  belongs_to :user
  belongs_to :badge

  validates :user_id, :badge_id, presence: true
  
  scope :earned, -> { where.not(earned_at: nil) }
  scope :claimed, -> { where.not(claimed_at: nil) }
  scope :unclaimed, -> { where(claimed_at: nil).where.not(earned_at: nil) }
  
  def reward_available?
    earned_at.present? && claimed_at.nil?
  end
  
  def claim_reward!
    update(claimed_at: Time.current) if reward_available?
  end
end 