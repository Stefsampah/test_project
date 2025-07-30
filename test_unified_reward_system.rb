#!/usr/bin/env ruby

# Script de test pour le système de récompenses unifiées
require_relative 'config/environment'

puts "🎯 Test du système de récompenses unifiées"
puts "=" * 50

# Récupérer un utilisateur de test
user = User.first
if user.nil?
  puts "❌ Aucun utilisateur trouvé. Créons-en un..."
  user = User.create!(
    email: 'test@example.com',
    password: 'password123',
    username: 'testuser'
  )
end

puts "👤 Utilisateur de test: #{user.email}"
puts "📊 Badges actuels: #{user.user_badges.count}"

# Nettoyer les récompenses existantes
user.rewards.destroy_all
puts "🧹 Récompenses existantes supprimées"

# Créer quelques badges de test
badge_types = ['competitor', 'engager', 'critic', 'challenger']
levels = ['bronze', 'silver', 'gold']

puts "\n🎖️ Attribution de badges de test..."

# Attribuer des badges progressivement
badge_counts = [1, 3, 6, 9, 12]

badge_counts.each do |count|
  puts "\n📈 Test avec #{count} badges..."
  
  # Supprimer tous les badges existants
  user.user_badges.destroy_all
  
  # Attribuer le nombre de badges requis
  count.times do |i|
    badge_type = badge_types[i % badge_types.length]
    level = levels[i % levels.length]
    
    badge = Badge.find_or_create_by(
      badge_type: badge_type,
      level: level,
      name: "#{badge_type.capitalize} #{level.capitalize}",
      description: "Badge #{badge_type} #{level}",
      points_required: (i + 1) * 10
    )
    
    user_badge = user.user_badges.create!(
      badge: badge,
      earned_at: Time.current,
      points_at_earned: user.points || 0
    )
    
    puts "  ✅ Badge créé: #{badge_type} #{level}"
  end
  
  puts "  📊 Total badges: #{user.user_badges.count}"
  
  # Vérifier les récompenses
  new_rewards = RewardNotificationService.check_and_notify_rewards(user)
  
  if new_rewards.any?
    puts "  🎉 Nouvelles récompenses débloquées:"
    new_rewards.each do |reward|
      puts "    - #{reward.reward_type.humanize} (#{reward.quantity_required} badges)"
    end
  else
    puts "  ⏳ Aucune nouvelle récompense débloquée"
  end
  
  # Afficher toutes les récompenses de l'utilisateur
  unlocked_rewards = user.rewards.unlocked
  if unlocked_rewards.any?
    puts "  🏆 Récompenses débloquées:"
    unlocked_rewards.each do |reward|
      puts "    - #{reward.reward_type.humanize} (#{reward.quantity_required} badges)"
    end
  end
end

puts "\n" + "=" * 50
puts "✅ Test terminé !"
puts "📊 Résumé:"
puts "  - Utilisateur: #{user.email}"
puts "  - Badges totaux: #{user.user_badges.count}"
puts "  - Récompenses débloquées: #{user.rewards.unlocked.count}"

# Afficher les récompenses finales
final_rewards = user.rewards.unlocked.order(:quantity_required)
if final_rewards.any?
  puts "\n🏆 Récompenses finales:"
  final_rewards.each do |reward|
    puts "  - #{reward.reward_type.humanize} (#{reward.quantity_required} badges)"
  end
else
  puts "\n❌ Aucune récompense débloquée"
end 