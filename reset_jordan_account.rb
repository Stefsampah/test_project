#!/usr/bin/env ruby
# Script pour réinitialiser le compte Jordan pour les tests
# À exécuter dans Rails console: rails runner reset_jordan_account.rb

puts "🔄 Réinitialisation du compte Jordan pour les tests"
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

# Supprimer tous les scores (optionnel - pour réinitialiser complètement)
puts "\n🗑️  Suppression des scores..."
deleted_scores = user.scores.count
user.scores.destroy_all
puts "   ✅ #{deleted_scores} scores supprimés"

# Réinitialiser les points (optionnel)
puts "\n🔄 Réinitialisation des points..."
user.update(points: 0)
puts "   ✅ Points réinitialisés à 0"

puts "\n✅ RÉINITIALISATION TERMINÉE"
puts "=" * 60
puts "Le compte Jordan est maintenant prêt pour les tests !"
puts "Vous pouvez maintenant jouer à toutes les playlists gratuites."


