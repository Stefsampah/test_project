class RewardsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    redirect_to my_rewards_path
  end
  
  def my_rewards
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
    # Toutes les récompenses de l'utilisateur pour l'affichage des récompenses par quantité
    @user_rewards = current_user.rewards.includes(:badge_type).order(:badge_type, :quantity_required)
    @rewards_by_type = @user_rewards.group_by(&:badge_type)
    
    # Statistiques globales
    @total_rewards = Reward.count
    @unlocked_rewards = Reward.unlocked.count
    @locked_rewards = Reward.where(unlocked: false).count
  end
  
  def show
    @reward = current_user.rewards.find(params[:id])
  end
  
  def unlock
    # Vérifier et créer les récompenses pour l'utilisateur
    Reward.check_and_create_rewards_for_user(current_user)
    
    redirect_to my_rewards_path, notice: 'Récompenses vérifiées et mises à jour !'
  end
end 