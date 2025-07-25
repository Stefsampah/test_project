class Reward < ApplicationRecord
  belongs_to :user
  belongs_to :badge_type, class_name: 'Badge', foreign_key: 'badge_type', primary_key: 'badge_type'
  
  validates :badge_type, presence: true
  validates :quantity_required, presence: true, numericality: { greater_than: 0 }
  validates :reward_type, presence: true
  validates :reward_description, presence: true
  
  enum reward_type: {
    challenge: 'challenge',
    exclusif: 'exclusif', 
    premium: 'premium'
  }
  
  scope :by_badge_type, ->(badge_type) { where(badge_type: badge_type) }
  scope :unlocked, -> { where(unlocked: true) }
  
  def self.check_and_create_rewards_for_user(user)
    # Vérifier chaque type de badge
    Badge.distinct.pluck(:badge_type).each do |badge_type|
      # Calculer les points pondérés par niveau
      badge_points = calculate_badge_points(user, badge_type)
      
      # Vérifier les conditions pour chaque niveau de récompense
      check_reward_condition(user, badge_type, 3, 'challenge') if badge_points >= 3
      check_reward_condition(user, badge_type, 6, 'exclusif') if badge_points >= 6
      check_reward_condition(user, badge_type, 9, 'premium') if badge_points >= 9
    end
  end
  
  # Méthode pour calculer les points pondérés par niveau
  def self.calculate_badge_points(user, badge_type)
    user_badges = user.user_badges.joins(:badge).where(badges: { badge_type: badge_type })
    
    bronze_count = user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    silver_count = user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    gold_count = user_badges.joins(:badge).where(badges: { level: 'gold' }).count
    
    # Pondération : Bronze=1, Silver=2, Gold=3
    (bronze_count * 1) + (silver_count * 2) + (gold_count * 3)
  end
  
  # Méthode pour vérifier si une récompense peut être débloquée
  def can_be_unlocked?(user)
    badge_points = self.class.calculate_badge_points(user, badge_type)
    badge_points >= quantity_required
  end
  
  # Méthode pour obtenir la progression actuelle (en points pondérés)
  def current_progress(user)
    self.class.calculate_badge_points(user, badge_type)
  end
  
  # Méthode pour obtenir le pourcentage de progression
  def progress_percentage(user)
    current = current_progress(user)
    [(current.to_f / quantity_required * 100), 100].min
  end
  
  private
  
  def self.check_reward_condition(user, badge_type, quantity_required, reward_type)
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
      r.reward_description = generate_reward_description(badge_type, quantity_required, reward_type)
      r.unlocked = true
      r.unlocked_at = Time.current
    end
    
    # Si la récompense existait mais n'était pas débloquée, la débloquer
    if reward.persisted? && !reward.unlocked?
      reward.update!(unlocked: true, unlocked_at: Time.current)
    end
  end
  
  def self.generate_reward_description(badge_type, quantity, reward_type)
    badge_type_name = badge_type.humanize
    case reward_type
    when 'challenge'
      "#{quantity} badges #{badge_type_name} - Défi spécial débloqué"
    when 'exclusif'
      "#{quantity} badges #{badge_type_name} - Contenu exclusif débloqué"
    when 'premium'
      "#{quantity} badges #{badge_type_name} - Récompense premium débloquée"
    end
  end
end 