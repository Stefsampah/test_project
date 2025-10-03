#!/usr/bin/env ruby

# Script pour examiner les conditions des badges et voir pourquoi ils ne s'attribuent pas
puts "🔍 Diagnostic des conditions de badges..."

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
puts "   - Game Points: #{admin.game_points}"
puts "   - Regularity Points: #{admin.regularity_points}"
puts "   - Listening Points: #{admin.listening_points}"
puts "   - Critical Opinions Points: #{admin.critical_opinions_points}"
puts "   - Total Points: #{admin.total_points}"
puts "   - Games: #{admin.games.count}"
puts "   - Swipes: #{admin.swipes.count}"
puts "   - Scores: #{admin.scores.count}"
puts "   - Playlists jouées: #{admin.playlists_per_day}"

puts "\n🧮 Score par catégorie détaillé:"
puts "   - Like count: #{admin.likes_count}"
puts "   - Dislike count: #{admin.dislikes_count}"
puts "   - Total swipes (non rewards): #{admin.swipes.joins(:playlist).where.not(playlists: { id: admin.send(:reward_playlist_ids) }).count}"

puts "\n📋 Badges dans la base de données:"
Badge.all.each do |badge|
  puts "\n🏅 #{badge.name} (#{badge.level.capitalize} #{badge.badge_type})"
  puts "   📈 Points requis: #{badge.points_required}"
  puts "   📝 Conditions: #{badge.conditions_description.presence || 'Pas de conditions spécifiques'}"
  puts "   ✅ Conditions remplies: #{badge.conditions_met?(admin)}"
  puts "   🎯 Score suffisant: #{admin.game_points >= badge.points_required}"
  puts "   🚫 Déjà gagné: #{admin.badges.include?(badge)}"
  
  if badge.condition_1_type.present?
    condition_value = badge.send("condition_1_value")
    actual_value = badge.check_condition(admin, badge.condition_1_type, condition_value)
    admin_value = case badge.condition_1_type
                  when 'regularity_points' then admin.regularity_points
                  when 'listening_points' then admin.listening_points
                  when 'critical_opinions' then admin.critical_opinions_points
                  when 'total_points' then admin.total_points
                  end
    puts "   🔧 Condition 1: #{badge.condition_1_type} (#{admin_value}/#{condition_value}) - #{actual_value ? '✅' : '❌'}"
  end
end

puts "\n🎯 Test d'attribution manuelle..."
initial_badges = admin.user_badges.count

# Tentative d'attribution manuelle de badges bronze simples
bronze_badges = Badge.where(level: 'bronze', condition_1_type: nil).limit(4)
bronze_badges.each do |badge|
  next if admin.badges.include?(badge)
  next unless admin.game_points >= badge.points_required
  
  admin.user_badges.create!(badge: badge, earned_at: Time.current, points_at_earned: admin.game_points)
  puts "✅ Badge attribué manuellement: #{badge.name}"
end

final_badges = admin.reload.user_badges.count
puts "\n📈 Badges ajoutés: #{final_badges - initial_badges}"
puts "🎯 Total badges: #{final_badges}"

puts "\n🔄 Test BadgeService..."
BadgeService.assign_badges(admin)
new_badges = admin.reload.user_badges.count
puts "📊 Badges après BadgeService: #{new_badges}"

puts "\n🎉 Si des badges ont été ajoutés, rechargez la page pour voir les changements !"
