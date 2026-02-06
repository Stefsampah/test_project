#!/usr/bin/env ruby
# Script pour RÉINITIALISER COMPLÈTEMENT le compte Jordan pour les tests
# Supprime TOUTES les données : jeux, swipes, scores, badges, récompenses, déblocages
# À exécuter dans Rails console: rails runner reset_jordan_account_complete.rb

puts "🔄 RÉINITIALISATION COMPLÈTE du compte Jordan pour les tests"
puts "=" * 60

# Trouver l'utilisateur Jordan
user = User.find_by(email: 'user@tubenplay.com')

if user.nil?
  puts "❌ Utilisateur Jordan (user@tubenplay.com) non trouvé"
  exit 1
end

puts "\n📊 État actuel de #{user.email}:"
puts "   - Jeux: #{user.games.count}"
puts "   - Swipes: #{user.swipes.count}"
puts "   - Scores: #{user.scores.count}"
puts "   - Badges: #{user.user_badges.count}"
puts "   - Récompenses: #{user.rewards.count}"
puts "   - Playlists débloquées: #{user.user_playlist_unlocks.count}"
puts "   - Points: #{user.points || 0}"

# Supprimer tous les jeux
puts "\n🗑️  Suppression des jeux..."
deleted_games = user.games.count
user.games.destroy_all
puts "   ✅ #{deleted_games} jeux supprimés"

# Supprimer tous les swipes
puts "\n🗑️  Suppression des swipes..."
deleted_swipes = user.swipes.count
user.swipes.destroy_all
puts "   ✅ #{deleted_swipes} swipes supprimés"

# Supprimer tous les scores
puts "\n🗑️  Suppression des scores..."
deleted_scores = user.scores.count
user.scores.destroy_all
puts "   ✅ #{deleted_scores} scores supprimés"

# Supprimer tous les badges
puts "\n🗑️  Suppression des badges..."
deleted_badges = user.user_badges.count
user.user_badges.destroy_all
puts "   ✅ #{deleted_badges} badges supprimés"

# Supprimer toutes les récompenses
puts "\n🗑️  Suppression des récompenses..."
deleted_rewards = user.rewards.count
user.rewards.destroy_all
puts "   ✅ #{deleted_rewards} récompenses supprimées"

# Supprimer tous les déblocages de playlists
puts "\n🗑️  Suppression des déblocages de playlists..."
deleted_unlocks = user.user_playlist_unlocks.count
user.user_playlist_unlocks.destroy_all
puts "   ✅ #{deleted_unlocks} déblocages supprimés"

# Réinitialiser les points
puts "\n🔄 Réinitialisation des points..."
user.update(points: 0)
puts "   ✅ Points réinitialisés à 0"

puts "\n✅ RÉINITIALISATION COMPLÈTE TERMINÉE"
puts "=" * 60
puts "Le compte Jordan est maintenant complètement réinitialisé !"
puts "Vous pouvez maintenant jouer à toutes les playlists gratuites comme un nouveau compte."


