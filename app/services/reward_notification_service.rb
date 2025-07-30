class RewardNotificationService
  def self.notify_new_rewards(user, new_rewards)
    return if new_rewards.empty?
    
    # Log des récompenses débloquées
    Rails.logger.info "🎉 #{user.email} a débloqué #{new_rewards.count} nouvelle(s) récompense(s):"
    new_rewards.each do |reward|
      Rails.logger.info "  - #{reward.reward_type.humanize} #{reward.badge_type.humanize} (#{reward.quantity_required} badges)"
    end
    
    # Ici on pourrait ajouter :
    # - Notifications push
    # - Emails de félicitations
    # - Animations dans l'interface
    # - Sons de célébration
  end
  
  def self.check_and_notify_rewards(user)
    # Récupérer les récompenses existantes
    existing_rewards = user.rewards.unlocked.pluck(:id)
    
    # Vérifier les nouvelles récompenses
    Reward.check_and_create_rewards_for_user(user)
    
    # Récupérer les nouvelles récompenses débloquées
    new_rewards = user.rewards.unlocked.where.not(id: existing_rewards)
    
    # Notifier si de nouvelles récompenses ont été débloquées
    notify_new_rewards(user, new_rewards) if new_rewards.any?
    
    new_rewards
  end
end 