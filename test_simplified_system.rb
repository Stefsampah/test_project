#!/usr/bin/env ruby

puts "🧪 Test du système de points simplifié..."
puts "=" * 50

# Test avec un utilisateur existant
user = User.first
if user
  puts "👤 Utilisateur testé : #{user.email}"
  puts ""
  
  puts "📊 Calculs des points :"
  puts "  Régularité : #{user.regularity_points} points (#{user.playlists_per_day.round(1)} playlists/jour)"
  puts "  Écoute : #{user.listening_points} points (#{user.watch_time_minutes} minutes)"
  puts "  Critique : #{user.critical_opinions_points} points (#{user.likes_count} likes, #{user.dislikes_count} dislikes)"
  puts "  Points de jeu : #{user.game_points} points"
  puts "  Points achetés : #{user.purchased_points} points"
  puts "  Total (badges) : #{user.total_points} points"
  puts ""
  
  puts "🏆 Badges disponibles :"
  user.obtainable_badges.each do |badge|
    puts "  ✅ #{badge.name} - #{badge.description}"
  end
  
  puts ""
  puts "🎯 Badges déjà obtenus :"
  user.badges.each do |badge|
    puts "  🏅 #{badge.name} - #{badge.description}"
  end
  
  puts ""
  puts "📈 Progression vers les prochains badges :"
  user.next_badges.each do |badge_type, info|
    if info[:badge]
      puts "  #{badge_type.capitalize} : #{info[:current_score]}/#{info[:badge].points_required} points"
      puts "    Points nécessaires : #{info[:points_needed]}"
    else
      puts "  #{badge_type.capitalize} : Tous les badges obtenus !"
    end
  end
else
  puts "❌ Aucun utilisateur trouvé pour le test"
end

puts ""
puts "✅ Test terminé !"
