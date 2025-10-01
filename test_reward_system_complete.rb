#!/usr/bin/env ruby

# Charger l'environnement Rails
require_relative 'config/environment'

# Script de test complet du système de récompenses
puts "🎯 Test Complet du Système de Récompenses"
puts "=" * 50

# 1. Vérifier l'état initial
puts "\n📊 État initial :"
User.all.each do |user|
  puts "\n#{user.email} :"
  puts "  Total badges : #{user.user_badges.count}"
  puts "  Récompenses : #{user.rewards.count}"
  puts "  Collection Arc-en-ciel : #{user.has_rainbow_collection? ? '✅' : '❌'}"
end

# 2. Simuler l'attribution de badges
puts "\n🎮 Simulation d'attribution de badges..."

User.all.each do |user|
  puts "\n--- Simulation pour #{user.email} ---"
  
  # Attacher quelques badges pour tester
  badges_to_assign = Badge.limit(5)
  
  badges_to_assign.each do |badge|
    unless user.badges.include?(badge)
      user_badge = user.user_badges.create!(
        badge: badge,
        earned_at: Time.current,
        points_at_earned: user.total_points
      )
      puts "  ✅ Badge attribué : #{badge.name}"
    end
  end
  
  # Vérifier la progression après attribution
  current_badges = user.user_badges.count
  progress = user.progress_to_next_digital_reward
  next_level = user.next_digital_reward_level
  
  puts "  📈 Progression :"
  puts "    Badges actuels : #{progress[0]}"
  puts "    Badges requis : #{progress[1]}"
  puts "    Prochaine récompense : #{next_level&.humanize || 'Aucune'}"
  
  # Vérifier les récompenses éligibles
  puts "  🎯 Récompenses éligibles :"
  if current_badges >= 3 && !user.has_reward_for_level?('challenge')
    puts "    ✅ Challenge (3 badges) - ÉLIGIBLE"
  elsif current_badges >= 3
    puts "    ✅ Challenge (3 badges) - DÉJÀ DÉBLOQUÉ"
  else
    puts "    ⏳ Challenge (3 badges) - #{3 - current_badges} de plus"
  end
  
  if current_badges >= 6 && !user.has_reward_for_level?('exclusif')
    puts "    ✅ Exclusif (6 badges) - ÉLIGIBLE"
  elsif current_badges >= 6
    puts "    ✅ Exclusif (6 badges) - DÉJÀ DÉBLOQUÉ"
  else
    puts "    ⏳ Exclusif (6 badges) - #{6 - current_badges} de plus"
  end
  
  if current_badges >= 9 && !user.has_reward_for_level?('premium')
    puts "    ✅ Premium (9 badges) - ÉLIGIBLE"
  elsif current_badges >= 9
    puts "    ✅ Premium (9 badges) - DÉJÀ DÉBLOQUÉ"
  else
    puts "    ⏳ Premium (9 badges) - #{9 - current_badges} de plus"
  end
  
  if user.has_rainbow_collection? && !user.has_reward_for_level?('ultime')
    puts "    ✅ Ultime (Collection Arc-en-ciel) - ÉLIGIBLE"
  elsif user.has_rainbow_collection?
    puts "    ✅ Ultime (Collection Arc-en-ciel) - DÉJÀ DÉBLOQUÉ"
  else
    puts "    ⏳ Ultime (Collection Arc-en-ciel) - Manque collection complète"
  end
end

# 3. Vérifier et débloquer les récompenses
puts "\n🚀 Vérification et déblocage des récompenses..."

User.all.each do |user|
  puts "\nVérification des récompenses pour #{user.email}..."
  
  # Vérifier et débloquer les nouvelles récompenses
  new_rewards = Reward.check_and_create_rewards_for_user(user)
  
  # Afficher les nouvelles récompenses créées
  if new_rewards.any?
    puts "  ✅ #{new_rewards.count} nouvelle(s) récompense(s) débloquée(s) :"
    new_rewards.each do |reward|
      puts "    - #{reward.reward_type.humanize} : #{reward.reward_description} (#{reward.content_type})"
    end
  else
    puts "  ⏳ Aucune nouvelle récompense débloquée"
  end
end

# 4. État final
puts "\n📊 État final :"
User.all.each do |user|
  puts "\n#{user.email} :"
  puts "  Total badges : #{user.user_badges.count}"
  puts "  Récompenses : #{user.rewards.count}"
  puts "  Collection Arc-en-ciel : #{user.has_rainbow_collection? ? '✅' : '❌'}"
  
  # Détails des récompenses
  if user.rewards.any?
    puts "  📋 Récompenses débloquées :"
    user.rewards.each do |reward|
      puts "    - #{reward.reward_type.humanize} : #{reward.reward_description}"
    end
  end
end

puts "\n✅ Test complet du système de récompenses terminé !"
puts "\n🎯 Résumé du système :"
puts "  • 3 badges = 1 récompense Challenge (aléatoire)"
puts "  • 6 badges = 1 récompense Exclusif (aléatoire)"
puts "  • 9 badges = 1 récompense Premium (aléatoire)"
puts "  • Collection Arc-en-ciel = 1 récompense Ultime (aléatoire)"
puts "  • Anti-répétition : jamais la même récompense 2 fois de suite"
puts "  • Système unifié : basé sur le total de badges collectés"
