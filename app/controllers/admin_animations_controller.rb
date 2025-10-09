# 🎉 Contrôleur Admin pour tester les animations
class AdminAnimationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  def index
    @user = current_user
    @recent_rewards = @user.rewards.order(created_at: :desc).limit(5)
    @recent_badges = @user.user_badges.includes(:badge).order(created_at: :desc).limit(5)
  end

  def test_reward_animation
    reward_type = params[:type] || 'challenge'
    
    # Créer une récompense de test
    reward = current_user.rewards.create!(
      reward_type: reward_type,
      badge_type: 'unified',
      quantity_required: get_quantity_for_type(reward_type),
      reward_description: "Récompense #{reward_type.humanize} de test",
      content_type: "test_#{reward_type}",
      unlocked: false
    )
    
    # Débloquer la récompense (déclenche l'animation)
    reward.update!(unlocked: true, unlocked_at: Time.current)
    
    flash[:success] = "Animation de récompense #{reward_type} déclenchée !"
    redirect_to admin_animations_path
  end

  def test_badge_animation
    badge_type = params[:type] || 'competitor'
    level = params[:level] || 'bronze'
    
    # Trouver ou créer le badge
    badge = Badge.find_or_create_by!(
      name: "#{level.capitalize} #{badge_type.capitalize}",
      badge_type: badge_type,
      level: level,
      points_required: get_points_for_level(level),
      reward_type: 'standard'
    )
    
    # Créer le UserBadge (déclenche l'animation)
    user_badge = current_user.user_badges.create!(
      badge: badge,
      earned_at: Time.current
    )
    
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
end
