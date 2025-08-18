#!/usr/bin/env ruby

# Script simple pour tester la page des récompenses exclusives
require_relative 'config/environment'

puts "🔍 Test de la page des récompenses exclusives"
puts "=" * 50

# Trouver l'utilisateur admin
user = User.find_by(email: 'admin@example.com')

if user.nil?
  puts "❌ Utilisateur admin@example.com non trouvé"
  exit 1
end

puts "✅ Utilisateur trouvé: #{user.email}"
puts "🏅 Badges: #{user.user_badges.count}"

# Vérifier les récompenses existantes
puts "\n📊 Récompenses existantes:"
all_rewards = user.rewards
puts "   Total: #{all_rewards.count}"

if all_rewards.any?
  all_rewards.each do |reward|
    puts "   - #{reward.reward_type}: #{reward.content_type} (unlocked: #{reward.unlocked})"
  end
else
  puts "   Aucune récompense"
end

# Vérifier spécifiquement les récompenses exclusives
puts "\n⭐ Récompenses exclusives:"
exclusif_rewards = user.rewards.where(reward_type: 'exclusif')
puts "   Total: #{exclusif_rewards.count}"

if exclusif_rewards.any?
  exclusif_rewards.each do |reward|
    puts "   - #{reward.content_type}: #{reward.reward_description} (unlocked: #{reward.unlocked})"
  end
else
  puts "   Aucune récompense exclusive"
end

# Vérifier les récompenses exclusives débloquées
puts "\n🔓 Récompenses exclusives débloquées:"
unlocked_exclusif = user.rewards.where(reward_type: 'exclusif', unlocked: true)
puts "   Total: #{unlocked_exclusif.count}"

if unlocked_exclusif.any?
  unlocked_exclusif.each do |reward|
    puts "   - #{reward.content_type}: #{reward.reward_description}"
  end
else
  puts "   Aucune récompense exclusive débloquée"
end

# Simuler ce que fait le contrôleur
puts "\n🎯 Simulation du contrôleur:"
current_user = user
unlocked_exclusif_rewards = current_user.rewards.where(reward_type: 'exclusif', unlocked: true).order(created_at: :desc)
puts "   @unlocked_exclusif_rewards: #{unlocked_exclusif_rewards.inspect}"

if unlocked_exclusif_rewards.nil?
  puts "   ❌ La variable est nil"
elsif unlocked_exclusif_rewards.respond_to?(:any?)
  puts "   ✅ La variable répond à .any?"
  puts "   Nombre d'éléments: #{unlocked_exclusif_rewards.count}"
else
  puts "   ❓ Type inattendu: #{unlocked_exclusif_rewards.class}"
end

puts "\n📝 Diagnostic:"
if unlocked_exclusif_rewards.nil?
  puts "   ❌ Le problème est que @unlocked_exclusif_rewards est nil"
  puts "   💡 Vérifiez que l'utilisateur est bien connecté"
elsif unlocked_exclusif_rewards.count == 0
  puts "   ℹ️ Aucune récompense exclusive débloquée"
  puts "   💡 L'utilisateur doit d'abord débloquer des récompenses exclusives"
else
  puts "   ✅ Tout semble normal"
end

puts "\n🚀 Pour résoudre le problème:"
puts "   1. Assurez-vous que l'utilisateur est connecté"
puts "   2. Débloquez des récompenses exclusives avec 6 badges"
puts "   3. Ou testez avec le script: ruby fix_exclusif_rewards.rb"
