class RewardsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    redirect_to my_rewards_path
  end
  
  def my_rewards
    # Récupérer uniquement les récompenses débloquées
    @rewards = current_user.rewards.where(unlocked: true).order(created_at: :desc)
    @unlocked_rewards = @rewards
    
    # Grouper par niveau de récompense pour l'affichage (uniquement débloquées)
    @challenge_rewards = @rewards.where(reward_type: 'challenge')
    @exclusif_rewards = @rewards.where(reward_type: 'exclusif')
    @premium_rewards = @rewards.where(reward_type: 'premium')
    @ultime_rewards = @rewards.where(reward_type: 'ultime')
    
    # Calculer la prochaine récompense accessible
    @next_accessible_reward = calculate_next_accessible_reward(current_user)
    
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
    
    # Progression vers la prochaine récompense
    @progress = current_user.progress_to_next_digital_reward
    @next_level = current_user.next_digital_reward_level
  end
  
  def all_rewards
    # Récupérer toutes les récompenses de l'utilisateur
    @user_rewards = current_user.rewards.order(:badge_type, :quantity_required)
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
    
    # Si c'est une récompense challenge, récupérer la playlist associée
    if @reward.content_type&.start_with?('challenge_reward_playlist')
      playlist_title = case @reward.content_type
                      when 'challenge_reward_playlist_1' then 'Challenge Reward Videos 1'
                      when 'challenge_reward_playlist_2' then 'Challenge Reward Videos 2'
                      when 'challenge_reward_playlist_3' then 'Challenge Reward Videos 3'
                      when 'challenge_reward_playlist_4' then 'Challenge Reward Videos 4'
                      when 'challenge_reward_playlist_5' then 'Challenge Reward Videos 5'
                      when 'challenge_reward_playlist_6' then 'Challenge Reward Videos 6'
                      when 'challenge_reward_playlist_7' then 'Challenge Reward Videos 7'
                      when 'challenge_reward_playlist_8' then 'Challenge Reward Videos 8'
                      when 'challenge_reward_playlist_9' then 'Challenge Reward Videos 9'
                      when 'challenge_reward_playlist_10' then 'Challenge Reward Videos 10'
                      when 'challenge_reward_playlist_11' then 'Challenge Reward Videos 11'
                      when 'challenge_reward_playlist_12' then 'Challenge Reward Videos 12'
                      when 'challenge_reward_playlist_13' then 'Challenge Reward Videos 13'
                      when 'challenge_reward_playlist_14' then 'Challenge Reward Videos 14'
                      when 'challenge_reward_playlist_15' then 'Challenge Reward Videos 15'
                      end
      
      @playlist = Playlist.find_by(title: playlist_title) if playlist_title
    end
  end
  
  def video_details
    @reward = current_user.rewards.find(params[:id])
    
    # Si c'est une récompense challenge, récupérer la playlist associée
    if @reward.content_type&.start_with?('challenge_reward_playlist')
      playlist_title = case @reward.content_type
                      when 'challenge_reward_playlist_1' then 'Challenge Reward Videos 1'
                      when 'challenge_reward_playlist_2' then 'Challenge Reward Videos 2'
                      when 'challenge_reward_playlist_3' then 'Challenge Reward Videos 3'
                      when 'challenge_reward_playlist_4' then 'Challenge Reward Videos 4'
                      when 'challenge_reward_playlist_5' then 'Challenge Reward Videos 5'
                      when 'challenge_reward_playlist_6' then 'Challenge Reward Videos 6'
                      when 'challenge_reward_playlist_7' then 'Challenge Reward Videos 7'
                      when 'challenge_reward_playlist_8' then 'Challenge Reward Videos 8'
                      when 'challenge_reward_playlist_9' then 'Challenge Reward Videos 9'
                      when 'challenge_reward_playlist_10' then 'Challenge Reward Videos 10'
                      when 'challenge_reward_playlist_11' then 'Challenge Reward Videos 11'
                      when 'challenge_reward_playlist_12' then 'Challenge Reward Videos 12'
                      when 'challenge_reward_playlist_13' then 'Challenge Reward Videos 13'
                      when 'challenge_reward_playlist_14' then 'Challenge Reward Videos 14'
                      when 'challenge_reward_playlist_15' then 'Challenge Reward Videos 15'
                      end
      
      @playlist = Playlist.find_by(title: playlist_title) if playlist_title
    end
    
    render 'video_details'
  end
  
  def details
    @badge_type = params[:badge_type] || 'unified'
    @quantity = params[:quantity].to_i
    @category = 'unified'
    
    # Calculer la progression pour le système unifié
    @current_count = current_user.user_badges.count
    @progress = [(@current_count.to_f / @quantity * 100), 100].min
    
    # Générer les informations de la récompense
    @reward_type = case @quantity
                   when 3 then 'challenge'
                   when 6 then 'exclusif'
                   when 9 then 'premium'
                   when 12 then 'ultime'
                   end
    
    @reward_name = case @quantity
                   when 3 then '🎯 Challenge'
                   when 6 then '⭐ Exclusif'
                   when 9 then '👑 Premium'
                   when 12 then '🏆 Ultime'
                   end
    
    @reward_description = generate_reward_description(@badge_type, @quantity, @reward_type, @category)
  end
  
  def unlock
    # Vérifier et créer les récompenses pour l'utilisateur avec notifications
    new_rewards = RewardNotificationService.check_and_notify_rewards(current_user)
    
    if new_rewards.any?
      redirect_to my_rewards_path, notice: "🎉 #{new_rewards.count} nouvelle(s) récompense(s) débloquée(s) !"
    else
      redirect_to my_rewards_path, notice: 'Récompenses vérifiées et mises à jour !'
    end
  end

  def exclusif
    # Page des récompenses exclusives (6 badges requis)
    @unlocked_exclusif_rewards = current_user.rewards.where(reward_type: 'exclusif', unlocked: true).order(created_at: :desc)
    
    # Statistiques des badges pour la progression
    @current_badge_count = current_user.user_badges.count
    @progress_percentage = [(@current_badge_count.to_f / 6 * 100), 100].min
    
    # Statistiques par niveau
    @bronze_count = current_user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    @silver_count = current_user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    @gold_count = current_user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
  end
  
  def challenge
    # Page des récompenses challenge (3 badges requis)
    @unlocked_challenge_rewards = current_user.rewards.where(reward_type: 'challenge', unlocked: true).order(created_at: :desc)
    
    # Statistiques des badges pour la progression
    @current_badge_count = current_user.user_badges.count
    @progress_percentage = [(@current_badge_count.to_f / 3 * 100), 100].min
    
    # Statistiques par niveau
    @bronze_count = current_user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    @silver_count = current_user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    @gold_count = current_user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
  end
  
  def partners
    # Page des partenaires et codes promo
    render 'partners'
  end
  
  private
  
  def generate_reward_description(badge_type, quantity, reward_type, category)
    case reward_type
    when 'challenge'
      "#{quantity} badges - Accès anticipé à des playlists + codes promo exclusifs"
    when 'exclusif'
      "#{quantity} badges - Photos dédicacées d'artistes + contenu exclusif"
    when 'premium'
      "#{quantity} badges - Rencontres avec des artistes + accès backstage virtuel"
    when 'ultime'
      "#{quantity} badges - Rencontre privée avec un artiste + accès backstage réel"
    end
  end
  
  def calculate_next_accessible_reward(user)
    badge_count = user.user_badges.count
    
    # Définir les niveaux de récompenses dans l'ordre
    reward_levels = [
      { level: 'challenge', quantity: 3, name: 'Challenge', icon: '🥉' },
      { level: 'exclusif', quantity: 6, name: 'Exclusif', icon: '🥈' },
      { level: 'premium', quantity: 9, name: 'Premium', icon: '🥇' },
      { level: 'ultime', quantity: 12, name: 'Ultime', icon: '🌈' }
    ]
    
    # Trouver la prochaine récompense accessible
    reward_levels.each do |reward_level|
      # Vérifier si l'utilisateur a déjà cette récompense
      existing_reward = user.rewards.where(reward_type: reward_level[:level], unlocked: true).first
      
      # Si la récompense n'existe pas et que l'utilisateur a assez de badges
      if !existing_reward && badge_count >= reward_level[:quantity]
        return {
          level: reward_level[:level],
          quantity: reward_level[:quantity],
          name: reward_level[:name],
          icon: reward_level[:icon],
          current_badges: badge_count,
          progress_percentage: [(badge_count.to_f / reward_level[:quantity] * 100), 100].min
        }
      end
    end
    
    # Si toutes les récompenses sont débloquées, retourner nil
    nil
  end
end 