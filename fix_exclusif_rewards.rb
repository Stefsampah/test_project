#!/usr/bin/env ruby

# Script pour résoudre le problème de contrainte d'unicité
# et recréer proprement les récompenses exclusives
require_relative 'config/environment'

puts "🔧 Correction du système de récompenses exclusives"
puts "=" * 60

# Trouver l'utilisateur admin
user = User.find_by(email: 'admin@example.com')

if user.nil?
  puts "❌ Utilisateur admin@example.com non trouvé"
  exit 1
end

puts "✅ Utilisateur trouvé: #{user.email}"

# Supprimer TOUTES les récompenses existantes pour cet utilisateur
puts "\n🗑️ Suppression de toutes les récompenses existantes..."
all_rewards = user.rewards
if all_rewards.any?
  puts "   Suppression de #{all_rewards.count} récompense(s)..."
  all_rewards.destroy_all
  puts "   ✅ Toutes les récompenses supprimées"
else
  puts "   ℹ️ Aucune récompense à supprimer"
end

# Vérifier que l'utilisateur a bien 6 badges
puts "\n🏅 Vérification des badges..."
if user.user_badges.count < 6
  puts "❌ L'utilisateur n'a que #{user.user_badges.count} badges, il en faut 6"
  exit 1
else
  puts "✅ L'utilisateur a #{user.user_badges.count} badges"
end

# Créer de nouvelles récompenses exclusives
puts "\n🔓 Création de nouvelles récompenses exclusives..."
new_rewards = Reward.check_and_create_rewards_for_user(user)

if new_rewards.any?
  puts "🎉 #{new_rewards.count} nouvelle(s) récompense(s) créée(s):"
  new_rewards.each do |reward|
    puts "  - #{reward.reward_type.humanize}: #{reward.content_type} - #{reward.reward_description}"
  end
else
  puts "ℹ️ Aucune nouvelle récompense créée"
end

# Afficher toutes les récompenses exclusives
puts "\n⭐ Récompenses exclusives actuelles:"
exclusif_rewards = user.rewards.where(reward_type: 'exclusif')
if exclusif_rewards.any?
  exclusif_rewards.each do |reward|
    puts "  - #{reward.content_type}: #{reward.reward_description}"
  end
else
  puts "  Aucune récompense exclusive"
end

puts "\n🎯 Test de la sélection aléatoire..."
puts "   Testons la sélection d'une récompense exclusive..."

# Tester la sélection aléatoire
begin
  selected_reward = Reward.select_random_reward(user, 'exclusif')
  if selected_reward
    puts "   🎯 Récompense sélectionnée: #{selected_reward[:content_type]}"
    puts "   📝 Nom: #{selected_reward[:name]}"
    puts "   📖 Description: #{selected_reward[:description]}"
    puts "   🎨 Icône: #{selected_reward[:icon]}"
  else
    puts "   ❌ Aucune récompense sélectionnée"
  end
rescue => e
  puts "   ❌ Erreur lors de la sélection: #{e.message}"
end

puts "\n✅ Correction terminée avec succès!"
puts "\n📝 Pour tester les récompenses exclusives:"
puts "   1. Assurez-vous que votre serveur Rails est en cours d'exécution"
puts "   2. Ouvrez votre navigateur et connectez-vous avec admin@example.com / 123456"
puts "   3. Visitez: /exclusif_rewards"
puts "   4. Testez le déblocage des récompenses exclusives"
puts "   5. Cliquez sur une récompense pour voir ses détails"
puts "   6. Vérifiez que les liens externes fonctionnent correctement"
