#!/usr/bin/env ruby

# Script de test pour le système de récompenses aléatoires
puts "🎲 Test du système de récompenses aléatoires"
puts "=" * 50

# 1. Vérifier les badges existants
puts "\n📊 Badges existants :"
User.all.each do |user|
  puts "\n#{user.email} :"
  puts "  Total badges : #{user.user_badges.count}"
  
  # Badges par niveau
  bronze = user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
  silver = user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
  gold = user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
  puts "  Bronze : #{bronze}, Silver : #{silver}, Gold : #{gold}"
  
  # Collection arc-en-ciel
  has_rainbow = user.has_rainbow_collection?
  puts "  Collection Arc-en-ciel : #{has_rainbow ? '✅' : '❌'}"
end

# 2. Tester le système de récompenses aléatoires
puts "\n🎁 Test du système de récompenses aléatoires :"

User.all.each do |user|
  puts "\n--- #{user.email} ---"
  
  # Vérifier les récompenses actuelles
  puts "📊 Récompenses actuelles :"
  user.rewards.each do |reward|
    puts "  - #{reward.reward_type.humanize} : #{reward.reward_description} (#{reward.content_type})"
  end
  
  # Vérifier la progression
  progress = user.progress_to_next_digital_reward
  next_level = user.next_digital_reward_level
  
  puts "\n📈 Progression :"
  puts "  Badges actuels : #{progress[0]}"
  puts "  Badges requis : #{progress[1]}"
  puts "  Prochaine récompense : #{next_level&.humanize || 'Aucune'}"
  
  # Vérifier les récompenses éligibles
  badge_count = user.user_badges.count
  has_rainbow = user.has_rainbow_collection?
  
  puts "\n🎯 Récompenses éligibles :"
  if badge_count >= 3 && !user.has_reward_for_level?('challenge')
    puts "  ✅ Challenge (3 badges) - ÉLIGIBLE"
  elsif badge_count >= 3
    puts "  ✅ Challenge (3 badges) - DÉJÀ DÉBLOQUÉ"
  else
    puts "  ⏳ Challenge (3 badges) - #{3 - badge_count} de plus"
  end
  
  if badge_count >= 6 && !user.has_reward_for_level?('exclusif')
    puts "  ✅ Exclusif (6 badges) - ÉLIGIBLE"
  elsif badge_count >= 6
    puts "  ✅ Exclusif (6 badges) - DÉJÀ DÉBLOQUÉ"
  else
    puts "  ⏳ Exclusif (6 badges) - #{6 - badge_count} de plus"
  end
  
  if badge_count >= 9 && !user.has_reward_for_level?('premium')
    puts "  ✅ Premium (9 badges) - ÉLIGIBLE"
  elsif badge_count >= 9
    puts "  ✅ Premium (9 badges) - DÉJÀ DÉBLOQUÉ"
  else
    puts "  ⏳ Premium (9 badges) - #{9 - badge_count} de plus"
  end
  
  if has_rainbow && !user.has_reward_for_level?('ultime')
    puts "  ✅ Ultime (Collection Arc-en-ciel) - ÉLIGIBLE"
  elsif has_rainbow
    puts "  ✅ Ultime (Collection Arc-en-ciel) - DÉJÀ DÉBLOQUÉ"
  else
    puts "  ⏳ Ultime (Collection Arc-en-ciel) - Manque collection complète"
  end
end

# 3. Appliquer le nouveau système
puts "\n🚀 Application du système de récompenses aléatoires..."

User.all.each do |user|
  puts "\nVérification des récompenses pour #{user.email}..."
  
  # Vérifier et débloquer les nouvelles récompenses
  Reward.check_and_create_rewards_for_user(user)
  
  # Afficher les nouvelles récompenses créées
  new_rewards = user.rewards.where('created_at >= ?', 1.minute.ago)
  if new_rewards.any?
    puts "  ✅ #{new_rewards.count} nouvelle(s) récompense(s) débloquée(s) :"
    new_rewards.each do |reward|
      puts "    - #{reward.reward_type.humanize} : #{reward.reward_description} (#{reward.content_type})"
    end
  else
    puts "  ⏳ Aucune nouvelle récompense débloquée"
  end
end

puts "\n✅ Test du système de récompenses aléatoires terminé !"
puts "\n🎯 Résumé du système :"
puts "  • 3 badges = 1 récompense Challenge (aléatoire)"
puts "  • 6 badges = 1 récompense Exclusif (aléatoire)"
puts "  • 9 badges = 1 récompense Premium (aléatoire)"
puts "  • Collection Arc-en-ciel = 1 récompense Ultime (aléatoire)"
puts "  • Anti-répétition : jamais la même récompense 2 fois de suite" 