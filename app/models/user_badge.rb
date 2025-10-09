class UserBadge < ApplicationRecord
  include BadgeAnimationTrigger
  
  belongs_to :user
  belongs_to :badge

  validates :user_id, :badge_id, presence: true
  
  scope :earned, -> { where.not(earned_at: nil) }
  
  # Callback pour vérifier les récompenses après attribution d'un badge
  after_create :check_rewards
  
  # Un badge gagné = récompense automatiquement disponible
  def reward_available?
    earned_at.present?
  end
  
  private
  
  def check_rewards
    # Vérifier et créer les récompenses pour l'utilisateur
    Reward.check_and_create_rewards_for_user(user)
  end
end 