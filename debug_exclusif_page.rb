#!/usr/bin/env ruby

# Script de debug pour la page des récompenses exclusives
require_relative 'config/environment'

puts "🔍 Debug de la page des récompenses exclusives"
puts "=" * 60

# Trouver l'utilisateur test
user = User.find_by(email: 'test@example.com')

if user.nil?
  puts "❌ Utilisateur test@example.com non trouvé"
  exit 1
end

puts "✅ Utilisateur trouvé: #{user.email}"
puts "🏅 Badges: #{user.user_badges.count}"

# Vérifier toutes les récompenses
puts "\n📊 Toutes les récompenses:"
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

# Simuler exactement ce que fait le contrôleur
puts "\n🎯 Simulation du contrôleur:"
current_user = user
unlocked_exclusif_rewards = current_user.rewards.where(reward_type: 'exclusif', unlocked: true).order(created_at: :desc) || []
puts "   @unlocked_exclusif_rewards: #{unlocked_exclusif_rewards.inspect}"

if unlocked_exclusif_rewards.nil?
  puts "   ❌ La variable est nil"
elsif unlocked_exclusif_rewards.respond_to?(:any?)
  puts "   ✅ La variable répond à .any?"
  puts "   Nombre d'éléments: #{unlocked_exclusif_rewards.count}"
else
  puts "   ❓ Type inattendu: #{unlocked_exclusif_rewards.class}"
end

# Vérifier si la récompense existe dans la base
puts "\n🔍 Vérification de la base de données:"
reward_in_db = Reward.where(user: user, reward_type: 'exclusif', unlocked: true).first
if reward_in_db
  puts "   ✅ Récompense trouvée en base: #{reward_in_db.content_type}"
  puts "   📝 Détails: #{reward_in_db.attributes}"
else
  puts "   ❌ Aucune récompense exclusive trouvée en base"
end

puts "\n📝 Diagnostic:"
if unlocked_exclusif_rewards.nil?
  puts "   ❌ Le problème est que @unlocked_exclusif_rewards est nil"
  puts "   💡 Vérifiez que l'utilisateur est bien connecté"
elsif unlocked_exclusif_rewards.count == 0
  puts "   ℹ️ Aucune récompense exclusive débloquée"
  puts "   💡 L'utilisateur doit d'abord débloquer des récompenses exclusives"
else
  puts "   ✅ Tout semble normal côté base de données"
  puts "   💡 Le problème pourrait être côté session/authentification"
end

puts "\n🚀 Solutions possibles:"
puts "   1. Vérifiez que vous êtes bien connecté avec test@example.com"
puts "   2. Essayez de vous reconnecter"
puts "   3. Videz le cache du navigateur"
puts "   4. Vérifiez que le serveur Rails est en cours d'exécution"
