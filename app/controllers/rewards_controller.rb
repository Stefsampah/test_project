class RewardsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    redirect_to my_rewards_path
  end
  
  def my_rewards
    @rewards = current_user.rewards.where(unlocked: true).order(created_at: :desc)
    @unlocked_rewards = @rewards
    
    @challenge_rewards = @rewards.where(reward_type: 'challenge')
    @exclusif_rewards = @rewards.where(reward_type: 'exclusif')
    @premium_rewards = @rewards.where(reward_type: 'premium')
    @ultime_rewards = @rewards.where(reward_type: 'ultime')
    
    @next_accessible_reward = calculate_next_accessible_reward(current_user)
    
    @badge_counts = {}
    Badge.distinct.pluck(:badge_type).each do |badge_type|
      @badge_counts[badge_type] = current_user.user_badges.joins(:badge).where(badges: { badge_type: badge_type }).count
    end
    
    @bronze_count = current_user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    @silver_count = current_user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    @gold_count = current_user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
    @total_badges = current_user.user_badges.count
    
    @progress = current_user.progress_to_next_digital_reward
    @next_level = current_user.next_digital_reward_level
  end
  
  def all_rewards
    @user_rewards = current_user.rewards.order(:badge_type, :quantity_required)
    @rewards_by_type = @user_rewards.group_by(&:badge_type)
    
    @badge_counts = {}
    Badge.distinct.pluck(:badge_type).each do |badge_type|
      @badge_counts[badge_type] = current_user.user_badges.joins(:badge).where(badges: { badge_type: badge_type }).count
    end
    
    @total_rewards = Reward.count
    @unlocked_rewards = Reward.unlocked.count
    @locked_rewards = Reward.where(unlocked: false).count
  end
  
  def show
    @reward = current_user.rewards.find(params[:id])
    
    if @reward.content_type&.start_with?('challenge_reward_playlist')
      playlist_title = case @reward.content_type
                      when 'challenge_reward_playlist_1' then 'Challenge Reward Playlist 1'
                      when 'challenge_reward_playlist_2' then 'Challenge Reward Playlist 2'
                      when 'challenge_reward_playlist_3' then 'Challenge Reward Playlist 3'
                      when 'challenge_reward_playlist_4' then 'Challenge Reward Playlist 4'
                      when 'challenge_reward_playlist_5' then 'Challenge Reward Playlist 5'
                      when 'challenge_reward_playlist_6' then 'Challenge Reward Playlist 6'
                      when 'challenge_reward_playlist_7' then 'Challenge Reward Playlist 7'
                      when 'challenge_reward_playlist_8' then 'Challenge Reward Playlist 8'
                      when 'challenge_reward_playlist_9' then 'Challenge Reward Playlist 9'
                      when 'challenge_reward_playlist_10' then 'Challenge Reward Playlist 10'
                      when 'challenge_reward_playlist_11' then 'Challenge Reward Playlist 11'
                      when 'challenge_reward_playlist_12' then 'Challenge Reward Playlist 12'
                      when 'challenge_reward_playlist_13' then 'Challenge Reward Playlist 13'
                      when 'challenge_reward_playlist_14' then 'Challenge Reward Playlist 14'
                      when 'challenge_reward_playlist_15' then 'Challenge Reward Playlist 15'
                      end
      
      @playlist = Playlist.find_by(title: playlist_title) if playlist_title
    end
    
    if @reward.reward_type == 'exclusif'
      @exclusif_content = get_exclusif_content_details(@reward.content_type)
    end
  end
  
  def reward_details
    @badge_type = params[:badge_type] || 'unified'
    @quantity = (params[:quantity] || 0).to_i
    @category = 'unified'
    
    @current_count = current_user.user_badges.count
    @progress = [(@current_count.to_f / @quantity * 100), 100].min
    
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
    
    @sample_reward = current_user.rewards.where(reward_type: @reward_type, unlocked: true).first
    
    @bronze_count = current_user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    @silver_count = current_user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    @gold_count = current_user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
    
    render 'details'
  end
  
  def test_details
    @badge_type = 'unified'
    @quantity = 3
    @category = 'unified'
    @current_count = current_user.user_badges.count
    @progress = [(@current_count.to_f / @quantity * 100), 100].min
    @reward_type = 'challenge'
    @reward_name = '🎯 Challenge'
    @reward_description = generate_reward_description(@badge_type, @quantity, @reward_type, @category)
    @sample_reward = current_user.rewards.where(reward_type: @reward_type, unlocked: true).first
    @bronze_count = current_user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    @silver_count = current_user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    @gold_count = current_user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
    render 'details'
  end
  
  def challenge
    @unlocked_challenge_rewards = current_user.rewards.where(reward_type: 'challenge', unlocked: true)
    @challenge_playlists = current_user.challenge_playlists
    
    @current_badge_count = current_user.user_badges.count
    @progress_percentage = [(@current_badge_count.to_f / 3 * 100), 100].min
    
    @bronze_count = current_user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    @silver_count = current_user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    @gold_count = current_user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
  end
  
  def unlock
    new_rewards = RewardNotificationService.check_and_notify_rewards(current_user)
    
    if new_rewards.any?
      redirect_to my_rewards_path, notice: "🎉 #{new_rewards.count} nouvelle(s) récompense(s) débloquée(s) !"
    else
      redirect_to my_rewards_path, notice: 'Récompenses vérifiées et mises à jour !'
    end
  end

  def exclusif
    @unlocked_exclusif_rewards = current_user.rewards.where(reward_type: 'exclusif', unlocked: true).order(created_at: :desc)
    
    @current_badge_count = current_user.user_badges.count
    @progress_percentage = [(@current_badge_count.to_f / 6 * 100), 100].min
    
    @bronze_count = current_user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    @silver_count = current_user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    @gold_count = current_user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
  end
  
  def partners
    render 'partners'
  end
  
  def video_details
    @reward = current_user.rewards.find(params[:id])
    render 'video_details'
  end
  
  private
  
  def get_exclusif_content_details(content_type)
    case content_type
    when 'didi_b_nouvelle_generation'
      {
        title: 'DIDI B EN STUDIO AVEC LA NOUVELLE GÉNÉRATION',
        description: 'Session studio avec Didi B et d\'autres artistes',
        icon: '🎹',
        color: 'from-purple-400 to-pink-500',
        link: '#',
        link_text: 'Regarder la session',
        type: 'Session Studio'
      }
    else
      {
        title: 'Contenu Exclusif',
        description: 'Contenu exclusif à découvrir',
        icon: '⭐',
        color: 'from-blue-400 to-purple-500',
        link: '#',
        link_text: 'Voir le contenu',
        type: 'Contenu Exclusif'
      }
    end
  end
  
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
    
    reward_levels = [
      { level: 'challenge', quantity: 3, name: 'Challenge', icon: '🥉' },
      { level: 'exclusif', quantity: 6, name: 'Exclusif', icon: '🥈' },
      { level: 'premium', quantity: 9, name: 'Premium', icon: '🥇' },
      { level: 'ultime', quantity: 12, name: 'Ultime', icon: '🌈' }
    ]
    
    reward_levels.each do |reward_level|
      existing_reward = user.rewards.where(reward_type: reward_level[:level], unlocked: true).first
      
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
    
    nil
  end
end 