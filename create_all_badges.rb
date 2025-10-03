#!/usr/bin/env ruby

# Script pour créer tous les badges avec des conditions raisonnables
puts "🏆 Création de tous les badges avec des conditions réalistes..."

# Charger l'environnement Rails
require_relative 'config/environment'

# Supprimer les badges existants s'ils existent
puts "🧹 Suppression des badges existants..."
Badge.destroy_all
UserBadge.destroy_all

# Créer les badges Competitor (basés sur les points de jeu)
competitor_badges = [
  { level: 'bronze', points_required: 100, description: 'Joueur compétitif débutant' },
  { level: 'silver', points_required: 500, description: 'Joueur compétitif confirmé' },
  { level: 'gold', points_required: 1000, description: 'Champion compétitif' }
]

# Créer les badges Engager (basés sur l'engagement)
engager_badges = [
  { level: 'bronze', points_required: 50, description: 'Premiers likes et dislikes' },
  { level: 'silver', points_required: 200, description: 'Engagement régulier' },
  { level: 'gold', points_required: 400, description: 'Super engagé' }
]

# Créer les badges Critic (basés sur les critiques constructives)
critic_badges = [
  { level: 'bronze', points_required: 30, description: 'Première critique' },
  { level: 'silver', points_required: 100, description: 'Critique constructive' },
  { level: 'gold', points_required: 200, description: 'Expert critique' }
]

# Créer les badges Challenger (basés sur les défis globaux)
challenger_badges = [
  { level: 'bronze', points_required: 150, description: 'Premier défi relevé' },
  { level: 'silver', points_required: 600, description: 'Challengeur confirmé' },
  { level: 'gold', points_required: 1200, description: 'Maître des défis' }
]

puts "\n🎯 Création des badges:"

# Competitor Badges
competitor_badges.each do |badge_data|
  badge = Badge.create!(
    name: "Competitor #{badge_data[:level].capitalize}",
    badge_type: 'competitor',
    level: badge_data[:level],
    points_required: badge_data[:points_required],
    description: badge_data[:description],
    condition_1_type: 'total_points',
    condition_1_value: badge_data[:points_required]
  )
  puts "✅ Competitor #{badge.level}: #{badge.name} (#{badge.points_required} pts)"
end

# Engager Badges
engager_badges.each do |badge_data|
  badge = Badge.create!(
    name: "Engager #{badge_data[:level].capitalize}",
    badge_type: 'engager',
    level: badge_data[:level],
    points_required: badge_data[:points_required],
    description: badge_data[:description],
    condition_1_type: 'critical_opinions',
    condition_1_value: badge_data[:points_required]
  )
  puts "✅ Engager #{badge.level}: #{badge.name} (#{badge.points_required} pts)"
end

# Critic Badges
critic_badges.each do |badge_data|
  badge = Badge.create!(
    name: "Critic #{badge_data[:level].capitalize}",
    badge_type: 'critic',
    level: badge_data[:level],
    points_required: badge_data[:points_required],
    description: badge_data[:description],
    condition_1_type: 'critical_opinions',
    condition_1_value: badge_data[:points_required]
  )
  puts "✅ Critic #{badge.level}: #{badge.name} (#{badge.points_required} pts)"
end

# Challenger Badges
challenger_badges.each do |badge_data|
  badge = Badge.create!(
    name: "Challenger #{badge_data[:level].capitalize}",
    badge_type: 'challenger',
    level: badge_data[:level],
    points_required: badge_data[:points_required],
    description: badge_data[:description],
    condition_1_type: 'total_points',
    condition_1_value: badge_data[:points_required]
  )
  puts "✅ Challenger #{badge.level}: #{badge.name} (#{badge.points_required} pts)"
end

puts "\n📊 Résumé des badges créés:"
puts "   - Competitor: #{Badge.where(badge_type: 'competitor').count}"
puts "   - Engager: #{ Badge.where(badge_type: 'engager').count}"
puts "   - Critic: #{Badge.where(badge_type: 'critic').count}"
puts "   - Challenger: #{Badge.where(badge_type: 'challenger').count}"
puts "   - Total: #{Badge.count}"

puts "\n🏆 Attribution des badges à l'admin..."
admin = User.find_by(email: 'admin@example.com')
if admin
  puts "👤 Trouvé: #{admin.email}"
  puts "📊 Points de l'admin: #{admin.game_points}"
  
  BadgeService.assign_badges(admin)
  
  badges_won = admin.reload.user_badges.count
  puts "✅ Badges attribués: #{badges_won}"
  
  if badges_won > 0
    puts "\n🏅 Badges gagnés par l'admin:"
    admin.user_badges.joins(:badge).includes(:badge).each do |user_badge|
      badge = user_badge.badge
      puts "   #{badge.level.upcase} #{badge.badge_type}: #{badge.name}"
    end
  end
else
  puts "❌ Admin non trouvé"
end

puts "\n🎉 Les badges sont maintenant disponibles !"
puts "🌐 Rechargez votre page profil pour voir les badges s'afficher !"
