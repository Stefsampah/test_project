#!/usr/bin/env ruby

puts "🔍 DEBUG - Vérification des récompenses"
puts "=" * 50

require_relative 'config/environment'

# Trouver l'utilisateur
user = User.first
if user.nil?
  puts "❌ Aucun utilisateur trouvé"
  exit 1
end

puts "👤 Utilisateur: #{user.email}"
puts "📊 Total badges: #{user.user_badges.count}"

# Vérifier les récompenses existantes
puts "\n🎁 RÉCOMPENSES EXISTANTES:"
rewards = user.rewards
puts "Total récompenses: #{rewards.count}"

if rewards.any?
  rewards.each do |reward|
    puts "  - ID: #{reward.id} | Type: #{reward.reward_type} | Content: #{reward.content_type} | Débloqué: #{reward.unlocked?}"
  end
else
  puts "  ❌ Aucune récompense trouvée"
end

# Vérifier les variables du contrôleur
puts "\n🔍 VARIABLES DU CONTRÔLEUR:"
challenge_rewards = rewards.where(reward_type: 'challenge')
exclusif_rewards = rewards.where(reward_type: 'exclusif')
premium_rewards = rewards.where(reward_type: 'premium')
ultime_rewards = rewards.where(reward_type: 'ultime')

puts "Challenge rewards: #{challenge_rewards.count}"
puts "Exclusif rewards: #{exclusif_rewards.count}"
puts "Premium rewards: #{premium_rewards.count}"
puts "Ultime rewards: #{ultime_rewards.count}"

# Vérifier les playlists
puts "\n📋 PLAYLISTS CHALLENGE:"
playlists = Playlist.where("title LIKE ?", "Challenge Reward Videos%")
puts "Playlists trouvées: #{playlists.count}"

playlists.each do |playlist|
  puts "  - #{playlist.title} (ID: #{playlist.id}) - #{playlist.videos.count} vidéos"
end

# Vérifier si les récompenses challenge ont des playlists associées
puts "\n🔗 RÉCOMPENSES AVEC PLAYLISTS:"
challenge_rewards.each do |reward|
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
      puts "  ✅ #{reward.content_type} -> #{playlist.title} (#{playlist.videos.count} vidéos)"
    else
      puts "  ❌ #{reward.content_type} -> Playlist non trouvée: #{playlist_title}"
    end
  end
end

puts "\n🎯 CONCLUSION:"
if challenge_rewards.any?
  puts "✅ Des récompenses challenge existent"
  puts "✅ Les boutons 'Voir détails' devraient s'afficher"
else
  puts "❌ Aucune récompense challenge trouvée"
  puts "💡 Exécutez: rails runner simulate_challenge_rewards.rb"
end
