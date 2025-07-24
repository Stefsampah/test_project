#!/usr/bin/env ruby

# Script de test pour le système de récompenses
require_relative 'config/environment'

puts "🧪 Test du système de récompenses"
puts "=" * 50

# Trouver un utilisateur de test
user = User.find_by(email: 'driss@example.com') || User.find_by(email: 'theo@example.com') || User.first

if user
  puts "👤 Utilisateur testé: #{user.email}"
  puts "📊 Badges actuels: #{user.user_badges.count}"
  
  # Afficher les badges par type
  Badge.distinct.pluck(:badge_type).each do |badge_type|
    count = user.user_badges.joins(:badge).where(badges: { badge_type: badge_type }).count
    puts "  - #{badge_type.humanize}: #{count} badges"
  end
  
  puts "\n🔍 Vérification des récompenses..."
  
  # Vérifier et créer les récompenses
  Reward.check_and_create_rewards_for_user(user)
  
  # Afficher les récompenses créées
  rewards = user.rewards
  puts "🎁 Récompenses créées: #{rewards.count}"
  
  rewards.each do |reward|
    status = reward.unlocked? ? "✅ Débloqué" : "🔒 Verrouillé"
    puts "  - #{reward.badge_type.humanize} (#{reward.quantity_required} badges): #{reward.reward_type.humanize} - #{status}"
  end
  
  puts "\n✅ Test terminé !"
else
  puts "❌ Aucun utilisateur trouvé pour le test"
end 