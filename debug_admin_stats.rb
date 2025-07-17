#!/usr/bin/env ruby

# Script pour déboguer les statistiques de l'admin
puts "🔍 Débogage des statistiques de l'admin..."

# Charger l'environnement Rails
require_relative 'config/environment'

# Trouver l'admin
admin = User.first
if admin.nil?
  puts "❌ Aucun utilisateur trouvé."
  exit 1
end

puts "👤 Admin: #{admin.email}"
puts "🎯 Points totaux: #{admin.total_points}"
puts "🎮 Parties jouées: #{admin.games.count}"
puts "🏆 Win ratio: #{admin.win_ratio}%"
puts "🥉 Top 3 count: #{admin.top_3_finishes_count}"
puts "🎵 Playlists uniques: #{admin.unique_playlists_played_count}"

puts "\n📊 Détail des parties:"
admin.games.includes(:playlist).each do |game|
  playlist = game.playlist
  user_score = admin.scores.find_by(playlist: playlist)&.points || 0
  
  # Calculer la position
  playlist_scores = Score.where(playlist: playlist).order(points: :desc)
  position = playlist_scores.where('points > ?', user_score).count + 1
  total_players = playlist_scores.count
  
  # Calculer le seuil top 75%
  top_75_threshold = playlist_scores.offset((total_players * 0.25).to_i).first&.points || 0
  is_win = user_score >= top_75_threshold
  
  puts "  - #{playlist.title}: #{user_score} points (#{position}/#{total_players}) - #{is_win ? '✅ Victoire' : '❌ Défaite'}"
  puts "    Seuil top 75%: #{top_75_threshold} points"
end

puts "\n🎯 Scores par playlist:"
admin.scores.includes(:playlist).each do |score|
  playlist = score.playlist
  playlist_scores = Score.where(playlist: playlist).order(points: :desc)
  position = playlist_scores.where('points > ?', score.points).count + 1
  total_players = playlist_scores.count
  
  puts "  - #{playlist.title}: #{score.points} points (#{position}/#{total_players})"
end 