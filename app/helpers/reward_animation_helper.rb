# 🎉 Helper pour les Animations de Récompenses - Tube'NPlay

module RewardAnimationHelper
  # 🎯 Afficher une animation de récompense
  def show_reward_animation(reward)
    return unless reward&.unlocked?
    
    reward_data = {
      type: reward.reward_type.humanize,
      title: reward.reward_description,
      description: get_reward_description(reward),
      level: reward.reward_type,
      points: reward.quantity_required
    }
    
    content_tag :div, '', 
      data: { 
        reward_to_show: reward_data.to_json,
        controller: 'reward-animation'
      },
      style: 'display: none;'
  end

  # 🎁 Bouton pour déclencher une animation de test
  def test_reward_animation_button(reward_type = 'challenge')
    content_tag :button, 
      "🎉 Tester Animation #{reward_type.humanize}", 
      onclick: "testRewardAnimation('#{reward_type}')",
      class: 'bg-gradient-to-r from-purple-500 to-pink-600 hover:from-purple-600 hover:to-pink-700 text-white px-6 py-3 rounded-full font-bold transition-all transform hover:scale-105 shadow-lg',
      style: 'margin: 10px;'
  end

  # 🎮 Panel de test des animations
  def reward_animation_test_panel
    return unless Rails.env.development?
    
    content_tag :div, class: 'fixed bottom-4 right-4 bg-gray-800 text-white p-4 rounded-lg shadow-2xl z-50' do
      content_tag(:h3, '🎮 Test Animations', class: 'text-lg font-bold mb-3') +
      content_tag(:div, class: 'space-y-2') do
        %w[challenge exclusif premium ultime].map do |type|
          test_reward_animation_button(type)
        end.join.html_safe
      end
    end
  end

  # 🎯 Notification de récompense disponible
  def reward_notification_badge(user)
    return unless user_signed_in?
    
    pending_rewards = user.rewards.where(unlocked: true, shown: false).count
    return if pending_rewards == 0
    
    content_tag :div, 
      pending_rewards.to_s,
      class: 'absolute -top-2 -right-2 bg-red-500 text-white text-xs rounded-full h-6 w-6 flex items-center justify-center font-bold animate-pulse',
      title: "#{pending_rewards} nouvelle(s) récompense(s) disponible(s) !"
  end

  # 🎊 Déclencher l'animation depuis le backend
  def trigger_reward_animation_from_backend(reward)
    return unless reward&.unlocked?
    
    # Marquer la récompense comme affichée
    reward.update(shown: true) if reward.respond_to?(:shown)
    
    # Déclencher l'animation via JavaScript
    javascript_tag do
      "setTimeout(() => {
        if (window.rewardAnimationSystem) {
          window.rewardAnimationSystem.triggerRewardAnimation({
            type: '#{reward.reward_type.humanize}',
            title: '#{j(reward.reward_description)}',
            description: '#{j(get_reward_description(reward))}',
            level: '#{reward.reward_type}',
            points: #{reward.quantity_required}
          });
        }
      }, 1000);".html_safe
    end
  end

  # 🎨 Styles pour les récompenses avec animations
  def animated_reward_card(reward, options = {})
    css_class = "reward-card animated-reward-card #{options[:class]}"
    css_class += ' unlocked' if reward.unlocked?
    css_class += ' premium' if reward.reward_type == 'premium'
    css_class += ' ultime' if reward.reward_type == 'ultime'
    
    content_tag :div, class: css_class, data: { reward_id: reward.id } do
      yield if block_given?
    end
  end

  # 🎯 Badge animé pour les récompenses
  def animated_reward_badge(reward)
    return unless reward.unlocked?
    
    content_tag :div, class: 'animated-reward-badge' do
      content_tag(:span, '🎉', class: 'badge-icon') +
      content_tag(:span, reward.reward_type.humanize, class: 'badge-text')
    end
  end

  private

  # 📝 Obtenir la description de la récompense
  def get_reward_description(reward)
    case reward.reward_type
    when 'challenge'
      "Vous avez débloqué une playlist exclusive ! Continuez à jouer pour plus de récompenses."
    when 'exclusif'
      "Accès à du contenu premium spécial ! Découvrez des playlists uniques et du contenu exclusif."
    when 'premium'
      "Contenu VIP et rencontres avec artistes ! Vous avez accès aux meilleures récompenses."
    when 'ultime'
      "Récompense ultime - vous êtes un champion ! Accès à tout le contenu premium."
    else
      "Nouvelle récompense disponible ! Continuez à jouer pour en débloquer d'autres."
    end
  end
end
