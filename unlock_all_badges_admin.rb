#!/usr/bin/env ruby

# Script pour débloquer tous les badges possibles pour l'admin
puts "🏆 Déblocage de tous les badges pour l'admin..."

# Charger l'environnement Rails
require_relative 'config/environment'

# Trouver l'admin
admin = User.find_by(email: 'admin@example.com')
if admin.nil?
  puts "❌ Admin non trouvé. Créez d'abord un utilisateur admin."
  exit 1
end

puts "👤 Admin trouvé: #{admin.email}"

# Débloquer tous les badges possible
badges_unlocked = []

# 1. Competitor badges
competitor_badges = Badge.where(badge_type: 'competitor').order(:points_required)
competitor_badges.each do |badge|
  unless admin.user_badges.exists?(badge: badge)
    admin.user_badges.create!(badge: badge, earned_at: Time.current)
    badges_unlocked << badge
    puts "✅ Badge Competitor débloqué: #{badge.name} (#{badge.level})"
  end
end

# 2. Engager badges
engager_badges = Badge.where(badge_type: 'engager').order(:points_required)
engager_badges.each do |badge|
  unless admin.user_badges.exists?(badge: badge)
    admin.user_badges.create!(badge: badge, earned_at: Time.current)
    badges_unlocked << badge
    puts "✅ Badge Engager débloqué: #{badge.name} (#{badge.level})"
  end
end

# 3. Critic badges
critic_badges = Badge.where(badge_type: 'critic').order(:points_required)
critic_badges.each do |badge|
  unless admin.user_badges.exists?(badge: badge)
    admin.user_badges.create!(badge: badge, earned_at: Time.current)
    badges_unlocked << badge
    puts "✅ Badge Critic débloqué: #{badge.name} (#{badge.level})"
  end
end

# 4. Challenger badges
challenger_badges = Badge.where(badge_type: 'challenger').order(:points_required)
challenger_badges.each do |badge|
  unless admin.user_badges.exists?(badge: badge)
    admin.user_badges.create!(badge: badge, earned_at: Time.current)
    badges_unlocked << badge
    puts "✅ Badge Challenger débloqué: #{badge.name} (#{badge.level})"
  end
end

puts "\n🎉 Résumé du déblocage:"
puts "📊 Badges débloqués ce tour: #{badges_unlocked.count}"
puts "🏆 Total badges de l'admin: #{admin.user_badges.count}"
puts "📈 Types débloquées: #{badges_unlocked.group_by(&:badge_type).map { |type, badges| "#{type}: #{badges.count}" }.join(', ')}"

puts "\n📋 Badges disponibles par niveau:"
['bronze', 'silver', 'gold'].each do |level|
  count = admin.user_badges.joins(:badge).where(badges: { level: level }).count
  puts "  #{level.capitalize}: #{count} badges"
end

puts "\n🚀 L'admin peut maintenant:"
puts "- ✅ Jouer à toutes les playlists premium"
puts "- ✅ Avoir accès à tous les contenus avancés"  
puts "- ✅ Voir tous les badges dans 'Mes Badges'"
puts "- ✅ Débloquer toutes les récompenses"

puts "\n🎯 Astuce: Connexez-vous avec admin@example.com pour tester !"

# Forcer la vérification des récompenses après attribution des badges
puts "\n🔍 Vérification des récompenses..."
Reward.check_and_create_rewards_for_user(admin)
rewards_count = admin.rewards.unlocked.count
puts "🎁 Les récompenses ont été vérifiées. Total récompenses débloquées: \"#{rewards_count}\""
