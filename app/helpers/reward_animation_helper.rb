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

  # 🎫 Carte de récompense avec design cohérent
  def unified_reward_card(reward, options = {})
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
    
    # Icône selon le type
    reward_icon = case reward_type
    when 'challenge'
      '🎯'
    when 'exclusif'
      '⭐'
    when 'premium'
      '👑'
    when 'ultime'
      '🎫'
    else
      '🎁'
    end
    
    # Design exactement identique à la carte d'animation
    content_tag :div, class: "unified-reward-card #{'unlocked' if is_unlocked}", style: "border-radius: 12px; box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05); border: 2px solid transparent; transition: all 0.3s ease; overflow: hidden; background: white; margin: 0 auto; max-width: 400px; width: 100%;" do
      # Bannière avec image - IDENTIQUE à l'animation
      content_tag(:div, style: "height: 200px; position: relative; overflow: hidden; background: linear-gradient(135deg, #{get_gradient_colors(reward_type)});") do
        # Image de fond
        content_tag(:div, '', style: "position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: url('#{background_image}') center/cover; opacity: 0.8;") +
        # Overlay de couleur selon le type
        content_tag(:div, '', style: "position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: #{get_overlay_color(reward_type)};") +
        # Badge du type
        content_tag(:div, style: "position: absolute; top: 15px; right: 15px;") do
          content_tag(:span, reward_type.upcase, style: "background: #{is_unlocked ? '#10b981' : '#6b7280'}; color: white; padding: 5px 10px; border-radius: 15px; font-size: 0.8rem; font-weight: bold;")
        end +
        # Overlay avec titre - IDENTIQUE à l'animation
        content_tag(:div, style: "position: absolute; inset: 0; background: rgba(0,0,0,0.2); display: flex; align-items: end; padding: 20px;") do
          content_tag(:div) do
            content_tag(:h3, reward_type.humanize, style: "font-size: 1.5rem; font-weight: bold; margin-bottom: 5px; color: white; text-shadow: 0 2px 4px rgba(0,0,0,0.8);") +
            content_tag(:div, "#{badge_requirement} badges requis", style: "color: rgba(255,255,255,0.8); font-size: 0.9rem;")
          end
        end
      end +
      # Contenu de la carte - COULEUR SELON LE TYPE
      content_tag(:div, style: "background: linear-gradient(135deg, #{get_content_gradient(reward_type)}); padding: 20px; color: white;") do
        content_tag(:p, reward_description, style: "font-size: 1rem; margin-bottom: 15px; line-height: 1.4; opacity: 0.9;") +
        content_tag(:div, style: "display: flex; justify-content: space-between; align-items: center; margin-top: 15px;") do
          content_tag(:div, style: "background: rgba(255, 255, 255, 0.2); padding: 6px 12px; border-radius: 15px; font-size: 0.8rem;") do
            content_tag(:span, "#{badge_requirement} badges", style: "color: #ffd700; font-weight: bold;") + " requis"
          end +
          content_tag(:div, style: "background: #{is_unlocked ? '#10b981' : '#6b7280'}; color: white; padding: 6px 12px; border-radius: 15px; font-size: 0.8rem; font-weight: bold;") do
            is_unlocked ? 'DÉBLOQUÉ' : 'VERROUILLÉ'
          end
        end +
        # Bouton "Afficher le contenu" si débloqué
        (is_unlocked ? 
          content_tag(:div, style: "margin-top: 15px; text-align: center;") do
            link_to "Afficher le contenu →", get_reward_details_path(badge_requirement), 
                    style: "background: #3b82f6; color: white; padding: 8px 16px; border-radius: 8px; font-size: 0.9rem; font-weight: bold; text-decoration: none; display: inline-block; transition: all 0.3s ease;",
                    onmouseover: "this.style.background='#2563eb'; this.style.transform='scale(1.05)';",
                    onmouseout: "this.style.background='#3b82f6'; this.style.transform='scale(1)';"
          end : 
          content_tag(:div, style: "margin-top: 15px; text-align: center;") do
            content_tag(:span, "🔒 Collectez #{badge_requirement - (reward.respond_to?(:user_badges_count) ? reward.user_badges_count : 0)} badge(s) supplémentaires", 
                       style: "color: #9ca3af; font-size: 0.8rem;")
          end
        )
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
      'Contenu exclusif à découvrir...'
    when 'exclusif'
      'Accès à des contenus rares...'
    when 'premium'
      'Expériences VIP uniques...'
    when 'ultime'
      'Récompense ultime mystérieuse...'
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
      'Contenu exclusif à découvrir...'
    when 'exclusif'
      'Accès à des contenus rares...'
    when 'premium'
      'Expériences VIP uniques...'
    when 'ultime'
      'Récompense ultime mystérieuse...'
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
      'linear-gradient(45deg, rgba(34,197,94,0.3) 0%, rgba(22,163,74,0.3) 100%)' # Vert - réduit
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
end
