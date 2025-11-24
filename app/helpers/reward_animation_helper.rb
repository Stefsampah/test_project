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

  # 🏆 Déclencher l'animation de badge depuis le backend
  def trigger_badge_animation_from_backend(user_badge)
    return unless user_badge&.earned_at.present?
    
    # Déclencher l'animation via JavaScript
    javascript_tag do
      "setTimeout(() => {
        if (window.rewardAnimationSystem) {
          window.rewardAnimationSystem.triggerBadgeAnimation({
            type: 'badge',
            title: '#{j(user_badge.badge.name)}',
            description: '#{j(get_badge_description(user_badge.badge))}',
            level: '#{user_badge.badge.level}',
            badge_type: '#{user_badge.badge.badge_type}',
            points_required: #{user_badge.badge.points_required},
            reward_type: '#{user_badge.badge.reward_type || 'standard'}'
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

  # 🎫 Carte de récompense avec design cohérent
  def unified_reward_card(reward, options = {})
    # Option pour désactiver les boutons d'action (utilisé sur la homepage)
    disable_actions = options[:disable_actions] || false
    # Gérer les objets Reward et les hash temporaires
    if reward.respond_to?(:unlocked?)
      is_unlocked = reward.unlocked?
      reward_type = reward.reward_type
      reward_title = get_reward_title(reward) # Utiliser le titre simplifié
      reward_description = get_reward_description(reward) # Utiliser la description mystérieuse
      badge_requirement = reward.quantity_required
    else
      # Pour les hash temporaires - utiliser les descriptions mystérieuses
      is_unlocked = reward[:unlocked] || reward['unlocked']
      reward_type = reward[:reward_type] || reward['reward_type']
      reward_title = get_reward_title_from_type(reward_type) # Titre simplifié
      reward_description = get_reward_description_from_type(reward_type) # Description mystérieuse
      badge_requirement = reward[:quantity_required] || reward['quantity_required']
    end
    
    # Couleurs différentes selon le type de récompense
    gradient_colors = case reward_type
    when 'challenge'
      'from-yellow-500 to-orange-600' # Jaune
    when 'exclusif'
      'from-purple-500 to-violet-600' # Violet
    when 'premium'
      'from-green-500 to-emerald-600' # Vert
    when 'ultime'
      'from-blue-500 to-cyan-600' # Bleu
    else
      'from-gray-500 to-gray-600'
    end
    
    # Images des vraies récompenses selon le type - TOUTES LES IMAGES en rotation aléatoire
    background_image = case reward_type
    when 'challenge'
      # TOUTES les 15 images des playlists challenge
      [
        'https://img.youtube.com/vi/qB7kLilZWwg/maxresdefault.jpg', # Latto - Somebody (Playlist 1)
        'https://img.youtube.com/vi/9ECNWJ1R0fg/maxresdefault.jpg', # Didi B Nouvelle Génération (Playlist 2)
        'https://img.youtube.com/vi/0tJz8JjPbHU/maxresdefault.jpg',  # Didi B Félicia (Playlist 3)
        'https://img.youtube.com/vi/QVvfSQP3JLM/maxresdefault.jpg', # Didi B Bouaké (Playlist 4)
        'https://img.youtube.com/vi/JWrIfPCyedU/maxresdefault.jpg', # Charles Doré (Playlist 5)
        'https://img.youtube.com/vi/ICvSOFEKbgs/maxresdefault.jpg', # Miki Accor Arena (Playlist 6)
        'https://img.youtube.com/vi/ORfP-QudA1A/maxresdefault.jpg', # Timeo (Playlist 7)
        'https://img.youtube.com/vi/VFvDwn2r5RI/maxresdefault.jpg',  # Marine (Playlist 8)
        'https://img.youtube.com/vi/qB7kLilZWwg/maxresdefault.jpg', # Latto - Somebody (Playlist 9)
        'https://img.youtube.com/vi/9ECNWJ1R0fg/maxresdefault.jpg', # Didi B Nouvelle Génération (Playlist 10)
        'https://img.youtube.com/vi/0tJz8JjPbHU/maxresdefault.jpg',  # Didi B Félicia (Playlist 11)
        'https://img.youtube.com/vi/QVvfSQP3JLM/maxresdefault.jpg', # Didi B Bouaké (Playlist 12)
        'https://img.youtube.com/vi/JWrIfPCyedU/maxresdefault.jpg', # Charles Doré (Playlist 13)
        'https://img.youtube.com/vi/ICvSOFEKbgs/maxresdefault.jpg', # Miki Accor Arena (Playlist 14)
        'https://img.youtube.com/vi/ORfP-QudA1A/maxresdefault.jpg'  # Timeo (Playlist 15)
      ].sample
    when 'exclusif'
      # TOUTES les images des contenus exclusifs (20+ contenus)
      [
        'https://img.youtube.com/vi/9ECNWJ1R0fg/maxresdefault.jpg', # Didi B Nouvelle Génération (Podcast)
        'https://img.youtube.com/vi/qB7kLilZWwg/maxresdefault.jpg', # Latto - Somebody (Podcast)
        'https://img.youtube.com/vi/JWrIfPCyedU/maxresdefault.jpg', # Charles Doré (Documentaire)
        'https://img.youtube.com/vi/QVvfSQP3JLM/maxresdefault.jpg', # Didi B Bouaké (Interview)
        'https://img.youtube.com/vi/ICvSOFEKbgs/maxresdefault.jpg', # Miki Accor Arena (Légendes Urbaines)
        'https://img.youtube.com/vi/ORfP-QudA1A/maxresdefault.jpg', # Timeo (La Télé d'Ici)
        'https://img.youtube.com/vi/VFvDwn2r5RI/maxresdefault.jpg', # Marine (Session studio)
        'https://img.youtube.com/vi/0tJz8JjPbHU/maxresdefault.jpg', # Didi B Félicia (CSTAR Session)
        'https://img.youtube.com/vi/qB7kLilZWwg/maxresdefault.jpg', # Latto - Somebody (Top Boy Live)
        'https://img.youtube.com/vi/9ECNWJ1R0fg/maxresdefault.jpg', # Didi B Nouvelle Génération (Timar feat ZZ)
        'https://img.youtube.com/vi/JWrIfPCyedU/maxresdefault.jpg', # Charles Doré (Octogone Philipayne)
        'https://img.youtube.com/vi/QVvfSQP3JLM/maxresdefault.jpg', # Didi B Bouaké (Reportage)
        'https://img.youtube.com/vi/ICvSOFEKbgs/maxresdefault.jpg', # Miki Accor Arena (Underground Ivoire)
        'https://img.youtube.com/vi/ORfP-QudA1A/maxresdefault.jpg', # Timeo (Session studio générale)
        'https://img.youtube.com/vi/VFvDwn2r5RI/maxresdefault.jpg', # Marine (Podcast exclusif)
        'https://img.youtube.com/vi/0tJz8JjPbHU/maxresdefault.jpg', # Didi B Félicia (Article blog)
        'https://img.youtube.com/vi/qB7kLilZWwg/maxresdefault.jpg', # Latto - Somebody (Documentaire)
        'https://img.youtube.com/vi/9ECNWJ1R0fg/maxresdefault.jpg', # Didi B Nouvelle Génération (Reportage)
        'https://img.youtube.com/vi/JWrIfPCyedU/maxresdefault.jpg', # Charles Doré (Commentaires audio)
        'https://img.youtube.com/vi/QVvfSQP3JLM/maxresdefault.jpg'  # Didi B Bouaké (Session studio)
      ].sample
    when 'premium'
      # TOUTES les 3 images des contenus premium
      [
        'https://img.youtube.com/vi/0tJz8JjPbHU/maxresdefault.jpg', # Didi B Félicia (Photos exclusives)
        'https://img.youtube.com/vi/QVvfSQP3JLM/maxresdefault.jpg', # Didi B Bouaké (Backstage vidéo)
        'https://img.youtube.com/vi/JWrIfPCyedU/maxresdefault.jpg'  # Charles Doré (Concert footage)
      ].sample
    when 'ultime'
      # Toutes les images des contenus ultimes (3 types)
      [
        'https://img.youtube.com/vi/ICvSOFEKbgs/maxresdefault.jpg', # Miki Accor Arena (Backstage)
        'https://img.youtube.com/vi/ORfP-QudA1A/maxresdefault.jpg', # Timeo (Concert)
        'https://img.youtube.com/vi/VFvDwn2r5RI/maxresdefault.jpg'  # Marine (VIP)
      ].sample
    else
      'https://img.youtube.com/vi/qB7kLilZWwg/maxresdefault.jpg' # Image par défaut
    end
    
    # Design Proposition 3 - Style Minimaliste Gaming
    reward_bg_class = case reward_type
    when 'challenge'
      'reward-challenge'
    when 'exclusif'
      'reward-exclusif'
    when 'premium'
      'reward-premium'
    when 'ultime'
      'reward-ultime'
    else
      'reward-challenge'
    end
    
    border_class = case reward_type
    when 'challenge'
      'border-challenge'
    when 'exclusif'
      'border-exclusif'
    when 'premium'
      'border-premium'
    when 'ultime'
      'border-ultime'
    else
      'border-challenge'
    end
    
    pass_text = case reward_type
    when 'challenge'
      'Des playlists que vous ne trouverez nulle part ailleurs. Versions acoustiques, remix spéciaux, titres rares.'
    when 'exclusif'
      'L\'envers du décor vous attend. Documentaires primés, interviews exclusives, podcasts underground.'
    when 'premium'
      'Rencontrez les artistes dans leur intimité. Sessions studio exclusives, backstage, photos rares.'
    when 'ultime'
      'L\'expérience ultime vous attend. Backstage réel, invitations concerts, rencontres privées.'
    else
      'Des playlists que vous ne trouverez nulle part ailleurs. Versions acoustiques, remix spéciaux, titres rares.'
    end
    
    title_style = reward_type == 'challenge' ? 
      "font-family: 'Orbitron', sans-serif; letter-spacing: 3px; transform: translateX(-10px); white-space: nowrap; display: inline-block; font-size: 1.875rem; font-weight: 900;" :
      "font-family: 'Orbitron', sans-serif; letter-spacing: 6px; font-size: 2.25rem; font-weight: 900;"
    
    # Couleur de fond selon le type
    background_gradient = case reward_type
    when 'challenge'
      'linear-gradient(135deg, #fb923c 0%, #f97316 50%, #ea580c 100%)'
    when 'exclusif'
      'linear-gradient(135deg, #cd7f32 0%, #b87333 50%, #9c6b2a 100%)'
    when 'premium'
      'linear-gradient(135deg, #c0c0c0 0%, #a8a8a8 50%, #808080 100%)'
    when 'ultime'
      'linear-gradient(135deg, #fbbf24 0%, #f59e0b 50%, #d97706 100%)'
    else
      'linear-gradient(135deg, #fb923c 0%, #f97316 50%, #ea580c 100%)'
    end
    
    content_tag :div, class: "game-card #{reward_bg_class} shine-effect unified-reward-card #{'unlocked' if is_unlocked}", style: "min-height: 400px; border-radius: 16px; overflow: hidden; transition: all 0.3s ease; cursor: pointer; position: relative; background: #{background_gradient}; margin-bottom: 20px;" do
      # VIP Clip
      content_tag(:div, '', class: "vip-clip #{border_class}", style: "position: absolute; top: -8px; left: 50%; transform: translateX(-50%); width: 60px; height: 20px; background: inherit; border-radius: 0 0 8px 8px; border: 2px solid rgba(0, 0, 0, 0.3); box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3); z-index: 5;") +
      # Bordure décorative
      content_tag(:div, '', class: "decorative-border #{border_class}", style: "position: absolute; inset: 0; border: 3px solid; border-radius: 16px; pointer-events: none; z-index: 1;") +
      # Contenu principal
      content_tag(:div, style: "padding: 1.5rem; height: 100%; display: flex; flex-direction: column; justify-content: space-between; position: relative; z-index: 10;") do
        # En-tête avec titre
        content_tag(:div, style: reward_type == 'challenge' ? "text-align: center; padding: 0 15px; overflow: visible; width: 100%;" : "text-align: center;") do
          content_tag(:div, reward_type.upcase, style: "color: white; margin-bottom: 1rem; #{title_style}") +
          content_tag(:div, '???', class: "mystery-badge", style: "background: rgba(0, 0, 0, 0.4); backdrop-filter: blur(10px); border: 2px solid rgba(255, 255, 255, 0.3); border-radius: 12px; padding: 8px 16px; font-weight: 700; letter-spacing: 2px; display: inline-block; color: white; margin-bottom: 1.5rem;")
        end +
        # Contenu central avec cadenas
        content_tag(:div, style: "flex: 1; display: flex; align-items: center; justify-content: center;") do
          content_tag(:div, style: "text-align: center;") do
            content_tag(:div, '🔒', style: "font-size: 3.75rem; margin-bottom: 1rem;") +
            content_tag(:div, "#{badge_requirement} badges requis", style: "color: rgba(255, 255, 255, 0.8); font-size: 0.875rem; font-weight: 600;")
          end
        end +
        # Footer avec description recommandée
          content_tag(:div, style: "text-align: center;") do
          content_tag(:div, pass_text, style: "color: rgba(255, 255, 255, 0.9); font-size: 0.875rem; font-weight: 500; line-height: 1.4; padding: 0 0.5rem;")
        end
      end
    end
  end

  private

  # 📝 Obtenir le titre de la récompense
  def get_reward_title(reward)
    case reward.reward_type
    when 'challenge'
      'Challenge'
    when 'exclusif'
      'Exclusif'
    when 'premium'
      'Premium'
    when 'ultime'
      'Ultime'
    else
      reward.reward_type.humanize
    end
  end

  # 📄 Obtenir la description de la récompense
  def get_reward_description(reward)
    case reward.reward_type
    when 'challenge'
      'Des playlists que vous ne trouverez nulle part ailleurs. Versions acoustiques, remix spéciaux, titres rares.'
    when 'exclusif'
      'L\'envers du décor vous attend. Documentaires primés, interviews exclusives, podcasts underground.'
    when 'premium'
      'Rencontrez les artistes dans leur intimité. Sessions studio exclusives, backstage, photos rares.'
    when 'ultime'
      'L\'expérience ultime vous attend. Backstage réel, invitations concerts, rencontres privées.'
    else
      'Contenu exclusif à découvrir'
    end
  end

  # 📝 Obtenir le titre de la récompense depuis le type
  def get_reward_title_from_type(reward_type)
    case reward_type
    when 'challenge'
      'Challenge'
    when 'exclusif'
      'Exclusif'
    when 'premium'
      'Premium'
    when 'ultime'
      'Ultime'
    else
      reward_type.humanize
    end
  end

  # 📄 Obtenir la description de la récompense depuis le type
  def get_reward_description_from_type(reward_type)
    case reward_type
    when 'challenge'
      'Des playlists que vous ne trouverez nulle part ailleurs. Versions acoustiques, remix spéciaux, titres rares.'
    when 'exclusif'
      'L\'envers du décor vous attend. Documentaires primés, interviews exclusives, podcasts underground.'
    when 'premium'
      'Rencontrez les artistes dans leur intimité. Sessions studio exclusives, backstage, photos rares.'
    when 'ultime'
      'L\'expérience ultime vous attend. Backstage réel, invitations concerts, rencontres privées.'
    else
      'Contenu exclusif à découvrir'
    end
  end

  # 🔗 Obtenir le chemin vers les détails de récompense
  def get_reward_details_path(badge_requirement)
    case badge_requirement
    when 3
      reward_details_path(badge_type: 'unified', quantity: 3)
    when 6
      reward_details_path(badge_type: 'unified', quantity: 6)
    when 9
      reward_details_path(badge_type: 'unified', quantity: 9)
    when 12
      reward_details_path(badge_type: 'unified', quantity: 12)
    else
      reward_details_path(badge_type: 'unified', quantity: badge_requirement)
    end
  end

  # 🎨 Obtenir les couleurs de gradient selon le type
  def get_gradient_colors(reward_type)
    case reward_type
    when 'challenge'
      '#eab308 0%, #ea580c 100%' # Jaune
    when 'exclusif'
      '#a855f7 0%, #7c3aed 100%' # Violet
    when 'premium'
      '#22c55e 0%, #16a34a 100%' # Vert
    when 'ultime'
      '#3b82f6 0%, #0891b2 100%' # Bleu
    else
      '#6b7280 0%, #4b5563 100%' # Gris
    end
  end

  # 🎨 Obtenir la couleur d'overlay selon le type (réduit pour voir mieux l'image)
  def get_overlay_color(reward_type)
    case reward_type
    when 'challenge'
      'linear-gradient(45deg, rgba(234,179,8,0.3) 0%, rgba(234,88,12,0.3) 100%)' # Jaune - réduit
    when 'exclusif'
      'linear-gradient(45deg, rgba(168,85,247,0.3) 0%, rgba(124,58,237,0.3) 100%)' # Violet - réduit
    when 'premium'
      'linear-gradient(45deg, rgba(34,197,94,0.3) 0%, rgba(22,163,74,0.3) 100%)' # Vert - réduit (correspond au contenu)
    when 'ultime'
      'linear-gradient(45deg, rgba(59,130,246,0.3) 0%, rgba(8,145,178,0.3) 100%)' # Bleu - réduit
    else
      'linear-gradient(45deg, rgba(107,114,128,0.3) 0%, rgba(75,85,99,0.3) 100%)' # Gris - réduit
    end
  end

  # 🎨 Obtenir les couleurs de gradient pour le contenu
  def get_content_gradient(reward_type)
    case reward_type
    when 'challenge'
      '#eab308 0%, #ea580c 100%' # Jaune
    when 'exclusif'
      '#a855f7 0%, #7c3aed 100%' # Violet
    when 'premium'
      '#22c55e 0%, #16a34a 100%' # Vert
    when 'ultime'
      '#3b82f6 0%, #0891b2 100%' # Bleu
    else
      '#6b7280 0%, #4b5563 100%' # Gris
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

  # 🏆 Obtenir la description pour l'animation de badge
  def get_badge_description(badge)
    case badge.badge_type
    when 'competitor'
      "Vous êtes un vrai compétiteur ! Continuez à jouer pour débloquer plus de badges."
    when 'engager'
      "Vous vous engagez dans le jeu ! Votre participation est remarquable."
    when 'critic'
      "Vous avez un œil critique ! Vos opinions comptent dans la communauté."
    when 'challenger'
      "Vous relevez tous les défis ! Vous êtes un champion du jeu."
    else
      "Nouveau badge débloqué ! Continuez à jouer pour en débloquer d'autres."
    end
  end
end
