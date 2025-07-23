class UserBadge < ApplicationRecord
  belongs_to :user
  belongs_to :badge

  validates :user_id, :badge_id, presence: true
  
  scope :earned, -> { where.not(earned_at: nil) }
  
  # Un badge gagné = récompense automatiquement disponible
  def reward_available?
    earned_at.present?
  end
end 