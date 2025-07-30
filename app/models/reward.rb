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
  
  scope :by_badge_type, ->(badge_type) { where(badge_type: badge_type) }
  scope :unlocked, -> { where(unlocked: true) }
  
  # Système simplifié : récompenses unifiées basées sur le total de badges
  def self.check_and_create_rewards_for_user(user)
    # Vérifier les récompenses unifiées
    check_unified_rewards(user)
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