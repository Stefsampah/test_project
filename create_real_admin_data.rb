#!/usr/bin/env ruby

# Script pour créer des données de jeu réalistes pour l'admin et déclencher les badges
puts "🎮 Création de données de jeu pour l'admin..."

# Charger l'environnement Rails
require_relative 'config/environment'

# Trouver l'admin
admin = User.find_by(email: 'admin@example.com')
if admin.nil?
  puts "❌ Admin non trouvé."
  exit 1
end

puts "👤 Admin: #{admin.email}"
puts "📊 Données actuelles:"
puts "   - Games: #{admin.games.count}"
puts "   - Swipes: #{admin.swipes.count}"
puts "   - Scores: #{admin.scores.count}"
puts "   - Badges: #{admin.user_badges.count}"

# Supprimer les données existantes pour repartir à zéro
puts "\n🧹 Nettoyage des données existantes..."
admin.games.destroy_all
admin.swipes.destroy_all
admin.scores.destroy_all
admin.user_badges.destroy_all

puts "✅ Nettoyage terminé"

# Prendre quelques playlists variées
playlists_to_test = Playlist.joins(:videos)
                           .includes(:videos)
                           .limit(8)
                           .pluck(:id)

puts "🎵 Playlists sélectionnées: #{playlists_to_test.count}"

# Créer des jeux et données pour chaque playlist
playlists_to_test.each_with_index do |playlist_id, index|
  playlist = Playlist.find(playlist_id)
  
  puts "\n🎮 Traitement playlist #{index + 1}: #{playlist.title}"
  
  # Créer un jeu terminé
  game = admin.games.create!(
    playlist: playlist,
    completed_at: Time.current - (index + 1).hours
  )
  
  # Créer des swipes réalistes (likes et dislikes mixtes)
  playlist.videos.limit(6).each_with_index do |video, video_index|
    # Mix de likes/dislikes pour créer des données crédibles
    action = video_index < 3 ? 'like' : 'dislike'
    liked_value = action == 'like'
    
    admin.swipes.create!(
      game: game,
      video: video,
      playlist: playlist,
      action: action,
      liked: liked_value
    )
  end
  
  # Créer un score basé sur les swipes
  likes_count = admin.swipes.where(playlist: playlist, action: 'like').count
  dislikes_count = admin.swipes.where(playlist: playlist, action: 'dislike').count
  score_points = (likes_count * 10) + (dislikes_count * 3) + rand(20..50)
  
  admin.scores.create!(
    playlist: playlist,
    points: score_points
  )
  
  puts "   ✅ Jeu terminé avec #{playlist.videos.limit(6).count} swipes"
  puts "   📊 Score: #{score_points} points"
end

puts "\n🏆 Attribution des badges..."
# Forcer l'attribution des badges
BadgeService.assign_badges(admin)

puts "\n📊 Résultat final:"
puts "   - Games: #{admin.reload.games.count}"
puts "   - Swipes: #{admin.swipes.count}"
puts "   - Scores: #{admin.scores.count}"
puts "   - Badges: #{admin.user_badges.count}"

if admin.user_badges.any?
  puts "\n🎯 Badges obtenus:"
  admin.user_badges.joins(:badge).includes(:badge).each do |user_badge|
    badge = user_badge.badge
    puts "   #{badge.level.upcase} #{badge.badge_type}: #{badge.name}"
  end
else
  puts "\n⚠️  Aucun badge attribué. Vérifier les conditions dans BadgeService."
end

puts "\n✅ Les données de test sont créées !"
puts "🌐 Rechargez la page profil de l'admin pour voir les badges."
puts "🎯 Points totals: #{admin.game_points} (points de jeu) + #{admin.points || 0} (points achetés) = #{admin.total_points}"
