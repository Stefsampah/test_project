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
  
  # Nouveau système basé sur les combinaisons de badges
  def self.check_and_create_rewards_for_user(user)
    # Vérifier les récompenses par type de badge
    check_badge_type_rewards(user)
    
    # Vérifier les récompenses par combinaisons mixtes
    check_mixed_badge_rewards(user)
    
    # Vérifier les récompenses par niveau de badge
    check_badge_level_rewards(user)
  end
  
  # Récompenses basées sur le nombre de badges d'un même type
  def self.check_badge_type_rewards(user)
    Badge.distinct.pluck(:badge_type).each do |badge_type|
      badge_count = user.user_badges.joins(:badge).where(badges: { badge_type: badge_type }).count
      
      # Récompenses par type : 3, 6, 9 badges du même type
      [3, 6, 9].each do |required_count|
        next if badge_count < required_count
        
        reward_type = case required_count
                     when 3 then 'challenge'
                     when 6 then 'exclusif'
                     when 9 then 'premium'
                     end
        
        check_reward_condition(user, badge_type, required_count, reward_type, "badge_type")
      end
    end
  end
  
  # Récompenses basées sur des combinaisons de badges de types différents
  def self.check_mixed_badge_rewards(user)
    total_badges = user.user_badges.count
    
    # Récompenses pour combinaisons mixtes
    [5, 8, 12].each do |required_count|
      next if total_badges < required_count
      
      reward_type = case required_count
                   when 5 then 'challenge'
                   when 8 then 'exclusif'
                   when 12 then 'premium'
                   end
      
      check_reward_condition(user, 'mixed', required_count, reward_type, "mixed")
    end
  end
  
  # Récompenses basées sur les niveaux de badges (Bronze, Silver, Gold)
  def self.check_badge_level_rewards(user)
    bronze_count = user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    silver_count = user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    gold_count = user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
    
    # Récompenses pour niveaux spécifiques
    check_level_combination(user, bronze_count, silver_count, gold_count)
  end
  
  def self.check_level_combination(user, bronze, silver, gold)
    # 3 Bronze = Challenge
    if bronze >= 3
      check_reward_condition(user, 'bronze', 3, 'challenge', "level")
    end
    
    # 2 Silver = Exclusif
    if silver >= 2
      check_reward_condition(user, 'silver', 2, 'exclusif', "level")
    end
    
    # 1 Gold = Premium
    if gold >= 1
      check_reward_condition(user, 'gold', 1, 'premium', "level")
    end
    
    # Combinaison mixte : 1 Bronze + 1 Silver + 1 Gold = Premium spécial
    if bronze >= 1 && silver >= 1 && gold >= 1
      check_reward_condition(user, 'rainbow', 3, 'premium', "rainbow")
    end
  end
  
  # Méthode pour vérifier si une récompense peut être débloquée
  def can_be_unlocked?(user)
    case reward_category
    when 'badge_type'
      badge_count = user.user_badges.joins(:badge).where(badges: { badge_type: badge_type }).count
      badge_count >= quantity_required
    when 'mixed'
      total_badges = user.user_badges.count
      total_badges >= quantity_required
    when 'level'
      level_count = user.user_badges.joins(:badge).where(badges: { level: badge_type }).count
      level_count >= quantity_required
    when 'rainbow'
      bronze = user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
      silver = user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
      gold = user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
      bronze >= 1 && silver >= 1 && gold >= 1
    else
      false
    end
  end
  
  # Méthode pour obtenir la progression actuelle
  def current_progress(user)
    case reward_category
    when 'badge_type'
      user.user_badges.joins(:badge).where(badges: { badge_type: badge_type }).count
    when 'mixed'
      user.user_badges.count
    when 'level'
      user.user_badges.joins(:badge).where(badges: { level: badge_type }).count
    when 'rainbow'
      bronze = user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
      silver = user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
      gold = user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
      [bronze, silver, gold].min
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
    when 'badge_type'
      Badge.distinct.pluck(:badge_type).map do |badge_type|
        current_count = user.user_badges.joins(:badge).where(badges: { badge_type: badge_type }).count
        next_level = case current_count
                    when 0..2 then { level: 'challenge', required: 3, current: current_count, remaining: 3 - current_count }
                    when 3..5 then { level: 'exclusif', required: 6, current: current_count, remaining: 6 - current_count }
                    when 6..8 then { level: 'premium', required: 9, current: current_count, remaining: 9 - current_count }
                    else { level: 'max', required: 9, current: current_count, remaining: 0 }
                    end
        { badge_type: badge_type, **next_level }
      end
    when 'mixed'
      total_badges = user.user_badges.count
      case total_badges
      when 0..4 then { level: 'challenge', required: 5, current: total_badges, remaining: 5 - total_badges }
      when 5..7 then { level: 'exclusif', required: 8, current: total_badges, remaining: 8 - total_badges }
      when 8..11 then { level: 'premium', required: 12, current: total_badges, remaining: 12 - total_badges }
      else { level: 'max', required: 12, current: total_badges, remaining: 0 }
      end
    end
  end
  
  private
  
  def reward_category
    # Déterminer la catégorie de récompense basée sur le badge_type
    case badge_type
    when 'mixed', 'rainbow' then badge_type
    when 'bronze', 'silver', 'gold' then 'level'
    else 'badge_type'
    end
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
    case category
    when 'badge_type'
      badge_type_name = badge_type.humanize
      case reward_type
      when 'challenge'
        "#{quantity} badges #{badge_type_name} - Défi spécial débloqué"
      when 'exclusif'
        "#{quantity} badges #{badge_type_name} - Contenu exclusif débloqué"
      when 'premium'
        "#{quantity} badges #{badge_type_name} - Récompense premium débloquée"
      end
    when 'mixed'
      case reward_type
      when 'challenge'
        "#{quantity} badges mixtes - Collection diversifiée débloquée"
      when 'exclusif'
        "#{quantity} badges mixtes - Contenu exclusif multi-genres débloqué"
      when 'premium'
        "#{quantity} badges mixtes - Récompense premium multi-genres débloquée"
      end
    when 'level'
      level_name = badge_type.humanize
      case reward_type
      when 'challenge'
        "#{quantity} badges #{level_name} - Défi #{level_name} débloqué"
      when 'exclusif'
        "#{quantity} badges #{level_name} - Contenu #{level_name} exclusif débloqué"
      when 'premium'
        "#{quantity} badges #{level_name} - Récompense #{level_name} premium débloquée"
      end
    when 'rainbow'
      case reward_type
      when 'premium'
        "Collection arc-en-ciel (Bronze + Silver + Gold) - Récompense ultime débloquée"
      end
    end
  end
end 