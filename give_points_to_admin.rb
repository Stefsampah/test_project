#!/usr/bin/env ruby

# Script pour donner des points à l'admin et débloquer toutes les playlists premium
puts "🎯 Attribution de points à l'admin..."

# Charger l'environnement Rails
require_relative 'config/environment'

# Trouver l'admin (premier utilisateur ou utilisateur avec email admin)
admin = User.first
if admin.nil?
  puts "❌ Aucun utilisateur trouvé. Créez d'abord un utilisateur."
  exit 1
end

puts "👤 Admin trouvé: #{admin.email}"

# Donner des points suffisants pour débloquer toutes les playlists premium
# Calculer le coût total des playlists premium
premium_playlists = Playlist.where(premium: true)
total_cost = premium_playlists.sum(:points_required)

puts "💰 Coût total des playlists premium: #{total_cost} points"
puts "📊 Nombre de playlists premium: #{premium_playlists.count}"

# Donner des points suffisants (un peu plus que nécessaire)
points_to_add = total_cost + 1000

# Mettre à jour les points de l'admin
admin.update!(points: points_to_add)

puts "✅ Points ajoutés à l'admin: #{points_to_add}"
puts "🎯 Points totaux de l'admin: #{admin.reload.points}"

# Débloquer toutes les playlists premium pour l'admin
premium_playlists.each do |playlist|
  UserPlaylistUnlock.find_or_create_by(
    user: admin,
    playlist: playlist
  )
end

puts "🔓 Toutes les playlists premium ont été débloquées pour l'admin"

# Afficher les playlists premium disponibles
puts "\n📋 Playlists premium disponibles:"
premium_playlists.each do |playlist|
  puts "  - #{playlist.title} (#{playlist.points_required} points)"
end

puts "\n🎉 L'admin peut maintenant jouer à toutes les playlists premium !"
puts "🌐 Testez les liens YouTube en jouant aux playlists." 