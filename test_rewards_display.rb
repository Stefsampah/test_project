#!/usr/bin/env ruby

puts "🔍 Test d'affichage des récompenses"
puts "=" * 40

require_relative 'config/environment'

user = User.first
puts "👤 Utilisateur: #{user.email}"

# Vérifier les récompenses challenge
challenge_rewards = user.rewards.where(reward_type: 'challenge')
puts "\n🎯 Récompenses challenge: #{challenge_rewards.count}"

challenge_rewards.each do |reward|
  puts "  - ID: #{reward.id} | Content: #{reward.content_type} | Débloqué: #{reward.unlocked?}"
end

# Vérifier les variables du contrôleur
puts "\n🔍 Variables du contrôleur:"
@rewards = user.rewards.includes(:badge_type).order(:created_at, :desc)
@challenge_rewards = @rewards.where(reward_type: 'challenge')
@exclusif_rewards = @rewards.where(reward_type: 'exclusif')
@premium_rewards = @rewards.where(reward_type: 'premium')
@ultime_rewards = @rewards.where(reward_type: 'ultime')

puts "Challenge rewards: #{@challenge_rewards.count}"
puts "Exclusif rewards: #{@exclusif_rewards.count}"
puts "Premium rewards: #{@premium_rewards.count}"
puts "Ultime rewards: #{@ultime_rewards.count}"

# Tester la logique has_reward
puts "\n🎯 Test de la logique has_reward:"
[
  { quantity: 3, level: 'challenge', rewards: @challenge_rewards },
  { quantity: 6, level: 'exclusif', rewards: @exclusif_rewards },
  { quantity: 9, level: 'premium', rewards: @premium_rewards },
  { quantity: 12, level: 'ultime', rewards: @ultime_rewards }
].each do |reward_info|
  has_reward = reward_info[:rewards].present? && reward_info[:rewards].any?
  puts "  #{reward_info[:level]}: #{reward_info[:rewards].count} récompenses -> has_reward: #{has_reward}"
end
