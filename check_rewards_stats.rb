#!/usr/bin/env ruby

puts "🎁 VÉRIFICATION DES RÉCOMPENSES"
puts "=" * 50

# Se connecter à Rails
require_relative 'config/environment'

puts "\n📊 Récompenses par type :"
reward_types = ['challenge', 'exclusif', 'premium', 'ultime']

reward_types.each do |type|
  count = Reward.where(reward_type: type).count
  puts "  #{type.capitalize.ljust(10)} : #{count} récompenses"
end

puts "\n📈 Statistiques générales :"
puts "  Total général : #{Reward.count} récompenses"

unlocked_count = Reward.where(unlocked: true).count
locked_count = Reward.where(unlocked: false).count
puts "  Débloquées    : #{unlocked_count} récompenses"
puts "  Verrouillées  : #{locked_count} récompenses"

puts "\n👥 Récompenses par utilisateur :"
User.all.each do |user|
  total_rewards = user.rewards.count
  unlocked_rewards = user.rewards.where(unlocked: true).count
  badges_count = user.user_badges.count
  
  puts "  #{user.email.ljust(25)} :"
  puts "    Badges collectés : #{badges_count}"
  puts "    Récompenses      : #{unlocked_rewards}/#{total_rewards} débloquées"
  
  # Détail par type
  reward_types.each do |type|
    type_count = user.rewards.where(reward_type: type, unlocked: true).count
    puts "      #{type.capitalize.ljust(9)} : #{type_count}" if type_count > 0
  end
  puts ""
end

puts "\n🏷️ Types de contenu disponibles :"
content_types = Reward.distinct.pluck(:content_type).compact.sort
content_types.each_with_index do |content, index|
  count = Reward.where(content_type: content).count
  reward_type = Reward.where(content_type: content).first&.reward_type || "inconnu"
  puts "  #{(index + 1).to_s.rjust(2)}. #{content.ljust(35)} (#{reward_type.ljust(9)}) : #{count}"
end

puts "\n🎯 Répartition par niveau de badges requis :"
[3, 6, 9, 12].each do |quantity|
  count = Reward.where(quantity_required: quantity).count
  type = case quantity
         when 3 then "Challenge"
         when 6 then "Exclusif"
         when 9 then "Premium"
         when 12 then "Ultime"
         end
  puts "  #{quantity.to_s.rjust(2)} badges (#{type.ljust(9)}) : #{count} récompenses"
end
