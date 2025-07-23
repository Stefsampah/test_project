#!/usr/bin/env ruby

# Script pour corriger les badges illégitimes
# Supprime les badges gagnés avec des points insuffisants

puts "🔧 Correction des badges illégitimes..."

User.all.each do |user|
  puts "\n👤 Utilisateur: #{user.email}"
  puts "📊 Points totaux: #{user.total_points}"
  
  user.user_badges.includes(:badge).each do |user_badge|
    badge = user_badge.badge
    points_required = badge.points_required
    points_at_earned = user_badge.points_at_earned
    
    puts "  - Badge: #{badge.name} (requiert #{points_required} points)"
    puts "    Points lors de l'obtention: #{points_at_earned}"
    
    if points_at_earned < points_required
      puts "    ❌ ILLÉGITIME - Suppression..."
      user_badge.destroy
    else
      puts "    ✅ LÉGITIME - Conservation"
    end
  end
end

puts "\n✅ Correction terminée !"
puts "💡 Les badges restants sont maintenant cohérents avec le gameplay." 