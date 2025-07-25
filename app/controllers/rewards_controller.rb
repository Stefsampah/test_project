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
    @current_points = Reward.calculate_badge_points(current_user, @badge_type)
    @progress = [(@current_points.to_f / @quantity * 100), 100].min
    
    # Calculer les détails par niveau
    user_badges = current_user.user_badges.joins(:badge).where(badges: { badge_type: @badge_type })
    @bronze_count = user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    @silver_count = user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    @gold_count = user_badges.joins(:badge).where(badges: { level: 'gold' }).count
    
    # Générer les informations de la récompense
    @reward_type = case @quantity
                   when 3 then 'challenge'
                   when 6 then 'exclusif'
                   when 9 then 'premium'
                   end
    
    @reward_name = case @quantity
                   when 3 then '🎯 Challenge'
                   when 6 then '⭐ Exclusif'
                   when 9 then '👑 Premium'
                   end
    
    @reward_description = case @quantity
                         when 3 then 'Défi spécial débloqué'
                         when 6 then 'Contenu exclusif débloqué'
                         when 9 then 'Récompense premium débloquée'
                         end
  end
  
  def unlock
    # Vérifier et créer les récompenses pour l'utilisateur
    Reward.check_and_create_rewards_for_user(current_user)
    
    redirect_to my_rewards_path, notice: 'Récompenses vérifiées et mises à jour !'
  end
end 