#!/usr/bin/env ruby

puts "🔍 Vérification de la cohérence du système simplifié..."
puts "=" * 60

# Test avec un utilisateur existant
user = User.first
if user
  puts "👤 Utilisateur testé : #{user.email}"
  puts ""
  
  puts "📊 Vérification des calculs :"
  puts "  Régularité : #{user.regularity_points} points (#{user.playlists_per_day.round(1)} playlists/jour)"
  puts "  Écoute : #{user.listening_points} points (#{user.watch_time_minutes} minutes)"
  puts "  Critique : #{user.critical_opinions_points} points (#{user.likes_count} likes, #{user.dislikes_count} dislikes)"
  puts "  Points de jeu : #{user.game_points} points"
  puts "  Points achetés : #{user.purchased_points} points"
  puts "  Total (badges) : #{user.total_points} points"
  puts ""
  
  puts "🏆 Vérification des badges :"
  puts "  Badges obtenus : #{user.badges.count}"
  puts "  Badges disponibles : #{user.obtainable_badges.count}"
  puts ""
  
  puts "📈 Vérification des scores :"
  top_engager = Score.calculate_top_engager_scores.first
  best_ratio = Score.calculate_best_ratio_scores.first
  wise_critic = Score.calculate_wise_critic_scores.first
  
  puts "  Top Engager : #{top_engager[:points]} points" if top_engager
  puts "  Top Régularité : #{best_ratio[:points]} points" if best_ratio
  puts "  Top Critic : #{wise_critic[:points]} points" if wise_critic
  puts ""
  
  puts "✅ Vérifications terminées !"
  puts ""
  puts "📋 Pages à vérifier manuellement :"
  puts "  - /simplified_stats (statistiques simplifiées)"
  puts "  - /scores (classements mis à jour)"
  puts "  - /profile (profil utilisateur)"
  puts "  - /my_badges (badges obtenus)"
  puts "  - /all_badges (tous les badges)"
else
  puts "❌ Aucun utilisateur trouvé pour le test"
end

puts ""
puts "🎉 Vérification terminée !"
