#!/usr/bin/env ruby

# Script de test pour le nouveau système de récompenses
# Basé sur les combinaisons de badges plutôt que les points pondérés

puts "🎯 Test du nouveau système de récompenses basé sur les combinaisons de badges"
puts "=" * 70

# 1. Vérifier les badges existants
puts "\n📊 Badges existants :"
Badge.all.each do |badge|
  puts "- #{badge.name} (#{badge.badge_type} #{badge.level})"
end

# 2. Vérifier les utilisateurs et leurs badges
puts "\n👥 Utilisateurs et leurs badges :"
User.all.each do |user|
  puts "\n#{user.email} :"
  puts "  Total badges : #{user.user_badges.count}"
  
  # Badges par type
  Badge.distinct.pluck(:badge_type).each do |badge_type|
    count = user.user_badges.joins(:badge).where(badges: { badge_type: badge_type }).count
    puts "  #{badge_type.humanize} : #{count} badges"
  end
  
  # Badges par niveau
  bronze = user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
  silver = user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
  gold = user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
  puts "  Bronze : #{bronze}, Silver : #{silver}, Gold : #{gold}"
end

# 3. Tester le nouveau système de récompenses
puts "\n🎁 Test du nouveau système de récompenses :"

User.all.each do |user|
  puts "\n--- #{user.email} ---"
  
  # Vérifier les récompenses par type de badge
  puts "📊 Récompenses par type de badge :"
  Badge.distinct.pluck(:badge_type).each do |badge_type|
    count = user.user_badges.joins(:badge).where(badges: { badge_type: badge_type }).count
    puts "  #{badge_type.humanize} : #{count} badges"
    
    [3, 6, 9].each do |required|
      if count >= required
        reward_type = case required
                     when 3 then 'Challenge'
                     when 6 then 'Exclusif'
                     when 9 then 'Premium'
                     end
        puts "    ✅ #{reward_type} débloqué (#{required} badges)"
      else
        puts "    ⏳ #{required - count} de plus pour débloquer"
      end
    end
  end
  
  # Vérifier les récompenses mixtes
  total_badges = user.user_badges.count
  puts "\n🌈 Récompenses mixtes : #{total_badges} badges total"
  [5, 8, 12].each do |required|
    if total_badges >= required
      reward_type = case required
                   when 5 then 'Challenge'
                   when 8 then 'Exclusif'
                   when 12 then 'Premium'
                   end
      puts "  ✅ #{reward_type} mixte débloqué (#{required} badges)"
    else
      puts "  ⏳ #{required - total_badges} de plus pour débloquer"
    end
  end
  
  # Vérifier les récompenses par niveau
  bronze = user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
  silver = user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
  gold = user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
  
  puts "\n🏅 Récompenses par niveau :"
  puts "  Bronze : #{bronze} badges"
  if bronze >= 3
    puts "    ✅ Challenge Bronze débloqué"
  else
    puts "    ⏳ #{3 - bronze} de plus pour Challenge Bronze"
  end
  
  puts "  Silver : #{silver} badges"
  if silver >= 2
    puts "    ✅ Exclusif Silver débloqué"
  else
    puts "    ⏳ #{2 - silver} de plus pour Exclusif Silver"
  end
  
  puts "  Gold : #{gold} badges"
  if gold >= 1
    puts "    ✅ Premium Gold débloqué"
  else
    puts "    ⏳ 1 de plus pour Premium Gold"
  end
  
  # Vérifier la collection arc-en-ciel
  if bronze >= 1 && silver >= 1 && gold >= 1
    puts "  🌈 Collection Arc-en-ciel débloquée !"
  else
    missing = []
    missing << "Bronze" if bronze < 1
    missing << "Silver" if silver < 1
    missing << "Gold" if gold < 1
    puts "  ⏳ Collection Arc-en-ciel : manque #{missing.join(', ')}"
  end
end

# 4. Appliquer le nouveau système
puts "\n🚀 Application du nouveau système de récompenses..."

User.all.each do |user|
  puts "\nVérification des récompenses pour #{user.email}..."
  
  # Supprimer les anciennes récompenses
  user.rewards.destroy_all
  
  # Créer les nouvelles récompenses
  Reward.check_and_create_rewards_for_user(user)
  
  # Afficher les récompenses créées
  unlocked_rewards = user.rewards.unlocked
  if unlocked_rewards.any?
    puts "  ✅ #{unlocked_rewards.count} récompenses débloquées :"
    unlocked_rewards.each do |reward|
      puts "    - #{reward.reward_type.humanize} #{reward.badge_type.humanize} (#{reward.quantity_required} badges)"
    end
  else
    puts "  ⏳ Aucune récompense débloquée pour le moment"
  end
end

puts "\n✅ Test du nouveau système terminé !"
puts "\n🎯 Résumé du nouveau système :"
puts "  • 3 badges du même type = Challenge"
puts "  • 6 badges du même type = Exclusif"
puts "  • 9 badges du même type = Premium"
puts "  • 5 badges mixtes = Challenge"
puts "  • 8 badges mixtes = Exclusif"
puts "  • 12 badges mixtes = Premium"
puts "  • 3 badges Bronze = Challenge"
puts "  • 2 badges Silver = Exclusif"
puts "  • 1 badge Gold = Premium"
puts "  • 1 Bronze + 1 Silver + 1 Gold = Collection Arc-en-ciel (Premium ultime)" 