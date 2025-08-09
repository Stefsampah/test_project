#!/usr/bin/env ruby

puts "🔍 Recherche des utilisateurs avec des récompenses challenge playlist simulées"
puts "=" * 70

# Charger l'environnement Rails
require_relative 'config/environment'

# Rechercher tous les utilisateurs avec des récompenses challenge
users_with_challenge_rewards = User.joins(:rewards).where(rewards: { reward_type: 'challenge' }).distinct

puts "\n👥 Utilisateurs trouvés avec des récompenses challenge : #{users_with_challenge_rewards.count}"

if users_with_challenge_rewards.any?
  users_with_challenge_rewards.each do |user|
    puts "\n--- #{user.email} ---"
    puts "📊 Total badges : #{user.user_badges.count}"
    
    # Récupérer toutes les récompenses challenge de cet utilisateur
    challenge_rewards = user.rewards.where(reward_type: 'challenge')
    puts "🎯 Récompenses challenge : #{challenge_rewards.count}"
    
    challenge_rewards.each do |reward|
      puts "  - ID: #{reward.id} | Content: #{reward.content_type} | Débloqué: #{reward.unlocked?} | Date: #{reward.unlocked_at&.strftime('%d/%m/%Y %H:%M')}"
      
      # Vérifier si c'est une playlist challenge
      if reward.content_type&.start_with?('challenge_reward_playlist')
        playlist_title = case reward.content_type
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
        
        playlist = Playlist.find_by(title: playlist_title) if playlist_title
        if playlist
          puts "    📋 Playlist associée : #{playlist.title} (#{playlist.videos.count} vidéos)"
        else
          puts "    ⚠️  Playlist non trouvée : #{playlist_title}"
        end
      end
    end
  end
else
  puts "❌ Aucun utilisateur avec des récompenses challenge trouvé"
end

# Rechercher spécifiquement les récompenses challenge_reward_playlist
puts "\n🎵 RÉCOMPENSES CHALLENGE PLAYLIST SPÉCIFIQUES :"
challenge_playlist_rewards = Reward.where("content_type LIKE ?", "challenge_reward_playlist%")

if challenge_playlist_rewards.any?
  puts "Total récompenses challenge playlist : #{challenge_playlist_rewards.count}"
  
  challenge_playlist_rewards.group_by(&:user).each do |user, rewards|
    puts "\n👤 #{user.email} :"
    rewards.each do |reward|
      puts "  - #{reward.content_type} (ID: #{reward.id}) - Débloqué le #{reward.unlocked_at&.strftime('%d/%m/%Y %H:%M')}"
    end
  end
else
  puts "❌ Aucune récompense challenge playlist trouvée"
end

puts "\n🎯 CONCLUSION :"
puts "Les utilisateurs listés ci-dessus ont des récompenses challenge playlist simulées"
puts "Ces récompenses ont été créées pour des tests et peuvent être utilisées pour tester le système"
