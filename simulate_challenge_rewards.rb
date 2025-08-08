#!/usr/bin/env ruby

# Script pour simuler le gain de toutes les récompenses challenge_reward_videos
puts "🎯 Simulation du gain de toutes les récompenses challenge_reward_videos"
puts "=" * 70

# Charger l'environnement Rails
require_relative 'config/environment'

# Trouver l'utilisateur (premier utilisateur ou admin)
user = User.first
if user.nil?
  puts "❌ Aucun utilisateur trouvé. Créez d'abord un utilisateur."
  exit 1
end

puts "👤 Utilisateur trouvé: #{user.email}"

# Vérifier si les playlists challenge existent
challenge_playlists = Playlist.where("title LIKE ?", "Challenge Reward Videos%")
puts "\n📋 Playlists challenge trouvées: #{challenge_playlists.count}"

if challenge_playlists.empty?
  puts "⚠️  Aucune playlist challenge trouvée. Exécutez d'abord le script add_challenge_reward_playlists_11_15.rb"
  exit 1
end

# Afficher les playlists trouvées
challenge_playlists.each do |playlist|
  puts "  - #{playlist.title} (ID: #{playlist.id}) - #{playlist.videos.count} vidéos"
end

# Supprimer les anciennes récompenses challenge pour éviter les doublons
puts "\n🗑️  Suppression des anciennes récompenses challenge..."
old_rewards = user.rewards.where("content_type LIKE ?", "challenge_reward_playlist%")
if old_rewards.any?
  old_rewards.destroy_all
  puts "  ✅ #{old_rewards.count} anciennes récompenses supprimées"
else
  puts "  ℹ️  Aucune ancienne récompense à supprimer"
end

# Créer toutes les récompenses challenge_reward_videos
puts "\n🎁 Création des récompenses challenge_reward_videos..."

challenge_rewards_data = [
  { content_type: 'challenge_reward_playlist_1', name: 'Challenge Reward Videos 1', description: 'Playlist exclusive débloquée via les récompenses challenge - Collection de 10 titres hip-hop et R&B', icon: '🎵' },
  { content_type: 'challenge_reward_playlist_2', name: 'Challenge Reward Videos 2', description: 'Deuxième playlist exclusive débloquée via les récompenses challenge - Artistes similaires', icon: '🎵' },
  { content_type: 'challenge_reward_playlist_3', name: 'Challenge Reward Videos 3', description: 'Troisième playlist exclusive débloquée via les récompenses challenge', icon: '🎵' },
  { content_type: 'challenge_reward_playlist_4', name: 'Challenge Reward Videos 4', description: 'Quatrième playlist exclusive débloquée via les récompenses challenge', icon: '🎵' },
  { content_type: 'challenge_reward_playlist_5', name: 'Challenge Reward Videos 5', description: 'Cinquième playlist exclusive débloquée via les récompenses challenge', icon: '🎵' },
  { content_type: 'challenge_reward_playlist_6', name: 'Challenge Reward Videos 6', description: 'Sixième playlist exclusive débloquée via les récompenses challenge - Versions alternatives', icon: '🎤' },
  { content_type: 'challenge_reward_playlist_7', name: 'Challenge Reward Videos 7', description: 'Septième playlist exclusive débloquée via les récompenses challenge - Versions alternatives', icon: '🎤' },
  { content_type: 'challenge_reward_playlist_8', name: 'Challenge Reward Videos 8', description: 'Huitième playlist exclusive débloquée via les récompenses challenge - Versions alternatives', icon: '🎧' },
  { content_type: 'challenge_reward_playlist_9', name: 'Challenge Reward Videos 9', description: 'Neuvième playlist exclusive débloquée via les récompenses challenge - Versions alternatives', icon: '🎧' },
  { content_type: 'challenge_reward_playlist_10', name: 'Challenge Reward Videos 10', description: 'Playlist exclusive de 10 titres hip-hop et R&B débloquée via les récompenses challenge', icon: '🎵' },
  { content_type: 'challenge_reward_playlist_11', name: 'Challenge Reward Videos 11', description: 'Playlist exclusive de remixes débloquée via les récompenses challenge', icon: '🎛️' },
  { content_type: 'challenge_reward_playlist_12', name: 'Challenge Reward Videos 12', description: 'Playlist exclusive de versions alternatives débloquée via les récompenses challenge', icon: '🎵' },
  { content_type: 'challenge_reward_playlist_13', name: 'Challenge Reward Videos 13', description: 'Playlist exclusive de versions live débloquée via les récompenses challenge', icon: '🎤' },
  { content_type: 'challenge_reward_playlist_14', name: 'Challenge Reward Videos 14', description: 'Playlist exclusive de versions instrumentales débloquée via les récompenses challenge', icon: '🎧' },
  { content_type: 'challenge_reward_playlist_15', name: 'Challenge Reward Videos 15', description: 'Playlist exclusive de versions exclusives débloquée via les récompenses challenge', icon: '⭐' }
]

created_rewards = []

challenge_rewards_data.each do |reward_data|
  # Vérifier si la playlist existe
  playlist = Playlist.find_by(title: reward_data[:name])
  
  if playlist
    # Vérifier si la récompense existe déjà
    existing_reward = user.rewards.find_by(content_type: reward_data[:content_type])
    
    if existing_reward
      puts "  ⚠️  Récompense déjà existante: #{reward_data[:name]} (ID: #{existing_reward.id})"
      created_rewards << existing_reward
    else
      # Créer la récompense avec un badge_type unique pour éviter les contraintes
      reward = user.rewards.create!(
        badge_type: "challenge_#{reward_data[:content_type]}",
        quantity_required: 3,
        reward_type: 'challenge',
        reward_description: reward_data[:description],
        content_type: reward_data[:content_type],
        unlocked: true,
        unlocked_at: Time.current
      )
      
      created_rewards << reward
      puts "  ✅ Récompense créée: #{reward_data[:name]} (ID: #{reward.id})"
    end
  else
    puts "  ⚠️  Playlist non trouvée: #{reward_data[:name]}"
  end
end

puts "\n🎉 RÉCOMPENSES CRÉÉES AVEC SUCCÈS !"
puts "📊 Statistiques :"
puts "  - Récompenses créées : #{created_rewards.count}"
puts "  - Utilisateur : #{user.email}"
puts "  - Date : #{Time.current.strftime('%d/%m/%Y %H:%M')}"

# Vérifier les récompenses créées
total_rewards = user.rewards.count
challenge_rewards = user.rewards.where(reward_type: 'challenge').count

puts "\n📈 Statistiques des récompenses :"
puts "  - Total des récompenses : #{total_rewards}"
puts "  - Récompenses challenge : #{challenge_rewards}"

# Afficher les récompenses créées
puts "\n🎁 Récompenses challenge créées :"
user.rewards.where(reward_type: 'challenge').order(:content_type).each do |reward|
  playlist = Playlist.find_by(title: reward.reward_description.split(' - ').first)
  video_count = playlist ? playlist.videos.count : 0
  puts "  - #{reward.content_type} : #{reward.reward_description} (#{video_count} vidéos)"
end

puts "\n🌐 URLs pour tester :"
puts "  - http://localhost:3000/my_rewards"
puts "  - http://localhost:3000/all_rewards"
puts "  - http://localhost:3000/playlists"
puts "\n🎯 Les playlists challenge devraient maintenant être visibles et accessibles !"
