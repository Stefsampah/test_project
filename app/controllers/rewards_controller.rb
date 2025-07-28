class RewardsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    redirect_to my_rewards_path
  end
  
  def my_rewards
    # Récupérer toutes les récompenses de l'utilisateur
    @rewards = current_user.rewards.includes(:badge_type).order(:badge_type, :quantity_required)
    @unlocked_rewards = @rewards.unlocked
    @locked_rewards = @rewards.where(unlocked: false)
    
    # Grouper par type de badge pour l'affichage
    @rewards_by_type = @rewards.group_by(&:badge_type)
    
    # Statistiques des badges par type
    @badge_counts = {}
    Badge.distinct.pluck(:badge_type).each do |badge_type|
      @badge_counts[badge_type] = current_user.user_badges.joins(:badge).where(badges: { badge_type: badge_type }).count
    end
    
    # Statistiques par niveau
    @bronze_count = current_user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    @silver_count = current_user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    @gold_count = current_user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
    @total_badges = current_user.user_badges.count
  end
  
  def all_rewards
    # Récupérer toutes les récompenses de l'utilisateur
    @user_rewards = current_user.rewards.includes(:badge_type).order(:badge_type, :quantity_required)
    @rewards_by_type = @user_rewards.group_by(&:badge_type)
    
    # Statistiques des badges par type
    @badge_counts = {}
    Badge.distinct.pluck(:badge_type).each do |badge_type|
      @badge_counts[badge_type] = current_user.user_badges.joins(:badge).where(badges: { badge_type: badge_type }).count
    end
    
    # Statistiques globales
    @total_rewards = Reward.count
    @unlocked_rewards = Reward.unlocked.count
    @locked_rewards = Reward.where(unlocked: false).count
  end
  
  def show
    @reward = current_user.rewards.find(params[:id])
  end
  
  def details
    @badge_type = params[:badge_type]
    @quantity = params[:quantity].to_i
    @category = params[:category] || 'badge_type'
    
    # Calculer la progression selon la catégorie
    case @category
    when 'badge_type'
      @current_count = current_user.user_badges.joins(:badge).where(badges: { badge_type: @badge_type }).count
    when 'mixed'
      @current_count = current_user.user_badges.count
    when 'level'
      @current_count = current_user.user_badges.joins(:badge).where(badges: { level: @badge_type }).count
    when 'rainbow'
      bronze = current_user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
      silver = current_user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
      gold = current_user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
      @current_count = [bronze, silver, gold].min
    end
    
    @progress = [(@current_count.to_f / @quantity * 100), 100].min
    
    # Générer les informations de la récompense
    @reward_type = case @quantity
                   when 1, 3 then 'challenge'
                   when 2, 6, 8 then 'exclusif'
                   when 9, 12 then 'premium'
                   end
    
    @reward_name = case @quantity
                   when 1, 3 then '🎯 Challenge'
                   when 2, 6, 8 then '⭐ Exclusif'
                   when 9, 12 then '👑 Premium'
                   end
    
    @reward_description = generate_reward_description(@badge_type, @quantity, @reward_type, @category)
  end
  
  def unlock
    # Vérifier et créer les récompenses pour l'utilisateur
    Reward.check_and_create_rewards_for_user(current_user)
    
    redirect_to my_rewards_path, notice: 'Récompenses vérifiées et mises à jour !'
  end
  
  private
  
  def generate_reward_description(badge_type, quantity, reward_type, category)
    case category
    when 'badge_type'
      badge_type_name = badge_type.humanize
      case reward_type
      when 'challenge'
        "Accès à une playlist exclusive #{badge_type_name}"
      when 'exclusif'
        "Accès à 3 playlists premium #{badge_type_name}"
      when 'premium'
        "Accès illimité à toutes les playlists #{badge_type_name}"
      end
    when 'mixed'
      case reward_type
      when 'challenge'
        "Accès à une collection de playlists mixtes"
      when 'exclusif'
        "Accès à 3 collections de playlists mixtes premium"
      when 'premium'
        "Accès illimité à toutes les collections mixtes"
      end
    when 'level'
      level_name = badge_type.humanize
      case reward_type
      when 'challenge'
        "Accès à des playlists #{level_name} exclusives"
      when 'exclusif'
        "Accès à 3 playlists #{level_name} premium"
      when 'premium'
        "Accès illimité à toutes les playlists #{level_name}"
      end
    when 'rainbow'
      case reward_type
      when 'premium'
        "Accès VIP à toutes les playlists + rencontre avec un artiste"
      end
    end
  end
end 