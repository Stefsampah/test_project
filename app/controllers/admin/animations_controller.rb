# 🎉 Contrôleur Admin pour tester les animations
module Admin
  class AnimationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  def index
    @user = current_user
    @recent_rewards = @user.rewards.order(created_at: :desc).limit(5)
    @recent_badges = @user.user_badges.includes(:badge).order(created_at: :desc).limit(5)
  end

  def test_reward_animation
    reward_type = params[:type] || 'challenge'
    
    # Trouver ou créer une récompense de test
    reward = current_user.rewards.find_or_create_by(
      reward_type: reward_type,
      badge_type: 'unified',
      quantity_required: get_quantity_for_type(reward_type)
    ) do |r|
      r.reward_description = "Récompense #{reward_type.humanize} de test"
      r.content_type = get_content_type_for_reward_type(reward_type)
      r.unlocked = false
    end
    
    # Débloquer la récompense (déclenche l'animation)
    reward.update!(unlocked: true, unlocked_at: Time.current)
    
    # Stocker les données d'animation pour le frontend
    animation_data = {
      type: 'reward',
      title: reward.reward_description,
      description: get_reward_animation_description(reward_type),
      reward_type: reward_type,
      points_required: reward.quantity_required,
      content_type: reward.content_type
    }
    
    Rails.cache.write("reward_animation_#{current_user.id}_#{reward.id}", animation_data, expires_in: 1.hour)
    
    # Déclencher l'animation via JavaScript
    flash[:animation_data] = animation_data.to_json
    
    flash[:success] = "Animation de récompense #{reward_type} déclenchée !"
    redirect_to admin_animations_path
  end

  def test_badge_animation
    badge_type = params[:type] || 'competitor'
    level = params[:level] || 'bronze'
    
    # Trouver ou créer le badge
    badge = Badge.find_or_create_by(
      badge_type: badge_type,
      level: level
    ) do |b|
      b.name = "#{level.capitalize} #{badge_type.capitalize}"
      b.points_required = get_points_for_level(level)
      b.reward_type = 'standard'
    end
    
    # Trouver ou créer le UserBadge (déclenche l'animation)
    user_badge = current_user.user_badges.find_or_create_by(badge: badge) do |ub|
      ub.earned_at = Time.current
      ub.points_at_earned = current_user.game_points
    end
    
    # Stocker les données d'animation pour le frontend
    animation_data = {
      type: 'badge',
      title: badge.name,
      description: get_badge_animation_description(badge_type),
      level: level,
      badge_type: badge_type,
      points_required: badge.points_required,
      reward_type: badge.reward_type || 'standard'
    }
    
    Rails.cache.write("badge_animation_#{current_user.id}_#{user_badge.id}", animation_data, expires_in: 1.hour)
    
    # Déclencher l'animation via JavaScript
    flash[:animation_data] = animation_data.to_json
    
    flash[:success] = "Animation de badge #{badge_type} #{level} déclenchée !"
    redirect_to admin_animations_path
  end

  def cleanup_test_data
    # Supprimer les récompenses de test
    test_rewards = current_user.rewards.where("reward_description LIKE ?", "%de test%")
    test_rewards.destroy_all
    
    # Supprimer les UserBadges de test
    test_badges = current_user.user_badges.joins(:badge).where("badges.name LIKE ?", "%test%")
    test_badges.destroy_all
    
    # Nettoyer le cache
    Rails.cache.clear
    
    flash[:success] = "Données de test nettoyées !"
    redirect_to admin_animations_path
  end

  def trigger_animation_from_cache
    animation_type = params[:type] # 'reward' ou 'badge'
    cache_key = params[:cache_key]
    
    if cache_key.present?
      data = Rails.cache.read(cache_key)
      if data
        # Déclencher l'animation via JavaScript
        @animation_data = data
        @animation_type = animation_type
        render :trigger_animation
      else
        flash[:error] = "Données d'animation non trouvées en cache"
        redirect_to admin_animations_path
      end
    else
      flash[:error] = "Clé de cache manquante"
      redirect_to admin_animations_path
    end
  end

  private

  def ensure_admin!
    unless current_user&.admin?
      flash[:error] = "Accès refusé. Admin requis."
      redirect_to root_path
    end
  end

  def get_quantity_for_type(type)
    case type
    when 'challenge' then 3
    when 'exclusif' then 6
    when 'premium' then 9
    when 'ultime' then 12
    else 3
    end
  end

  def get_points_for_level(level)
    case level
    when 'bronze' then 500
    when 'silver' then 1000
    when 'gold' then 2000
    else 500
    end
  end

  def get_content_type_for_reward_type(reward_type)
    case reward_type
    when 'challenge' then 'challenge_reward_playlist_1'
    when 'exclusif' then 'podcast_exclusive'
    when 'premium' then 'backstage_video'
    when 'ultime' then 'personal_voice_message'
    else 'challenge_reward_playlist_1'
    end
  end

  def get_badge_animation_description(badge_type)
    case badge_type
    when 'competitor'
      "🏆 Vous êtes un vrai compétiteur ! Continuez à jouer pour débloquer plus de badges."
    when 'engager'
      "🎮 Vous vous engagez dans le jeu ! Votre participation est remarquable."
    when 'critic'
      "🎯 Vous avez un œil critique ! Vos opinions comptent dans la communauté."
    when 'challenger'
      "⚡ Vous relevez tous les défis ! Vous êtes un champion du jeu."
    else
      "🏅 Nouveau badge débloqué ! Continuez à jouer pour en débloquer d'autres."
    end
  end

  def get_reward_animation_description(reward_type)
    case reward_type
    when 'challenge'
      "🎵 Vous avez débloqué une playlist exclusive ! Découvrez de nouveaux artistes et morceaux."
    when 'exclusif'
      "⭐ Contenu exclusif disponible ! Accédez à du contenu premium spécial."
    when 'premium'
      "👑 Contenu VIP et rencontres avec artistes ! Profitez d'expériences uniques."
    when 'ultime'
      "🏆 Récompense ultime - vous êtes un champion ! Expérience exceptionnelle débloquée."
    else
      "🎁 Nouvelle récompense disponible ! Continuez à jouer pour en débloquer d'autres."
    end
  end
  end
end
