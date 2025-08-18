#!/usr/bin/env ruby

# Script de test pour les récompenses exclusives
puts "🧪 Test des récompenses exclusives"
puts "=" * 50

# Charger l'environnement Rails
require_relative 'config/environment'

# Trouver un utilisateur de test
user = User.first
if user.nil?
  puts "❌ Aucun utilisateur trouvé dans la base de données"
  exit 1
end

puts "👤 Utilisateur de test: #{user.email}"
puts "🏅 Badges actuels: #{user.user_badges.count}"

# Vérifier les récompenses existantes
puts "\n📊 Récompenses existantes:"
user.rewards.each do |reward|
  puts "  - #{reward.reward_type.humanize} (#{reward.content_type}): #{reward.reward_description}"
end

# Simuler l'obtention de 6 badges pour débloquer les récompenses exclusives
if user.user_badges.count < 6
  puts "\n🎯 Simulation de l'obtention de badges..."
  
  # Créer des badges de test si nécessaire
  badge_types = ['bronze', 'silver', 'gold']
  (6 - user.user_badges.count).times do |i|
    badge_type = badge_types[i % 3]
    level = badge_type
    badge_type_name = "test_#{badge_type}_#{i + 1}"
    
    badge = Badge.find_or_create_by!(badge_type: badge_type_name, level: level) do |b|
      b.title = "Badge Test #{badge_type.capitalize} #{i + 1}"
      b.description = "Badge de test pour les récompenses exclusives"
      b.points = 100
      b.reward_type = 'standard'
      b.reward_description = 'Badge de test'
    end
    
    UserBadge.find_or_create_by!(user: user, badge: badge) do |ub|
      ub.earned_at = Time.current
    end
    
    puts "  ✅ Badge #{badge_type.capitalize} #{i + 1} créé et attribué"
  end
end

puts "\n🏅 Badges après simulation: #{user.user_badges.count}"

# Vérifier et créer les récompenses exclusives
puts "\n🔓 Vérification des récompenses exclusives..."
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
puts "\n⭐ Récompenses exclusives débloquées:"
exclusif_rewards = user.rewards.where(reward_type: 'exclusif')
if exclusif_rewards.any?
  exclusif_rewards.each do |reward|
    puts "  - #{reward.content_type}: #{reward.reward_description}"
  end
else
  puts "  Aucune récompense exclusive débloquée"
end

# Tester la sélection aléatoire
puts "\n🎲 Test de la sélection aléatoire des récompenses exclusives..."
puts "Types de contenu disponibles pour les récompenses exclusives:"

# Récupérer les types de contenu exclusif depuis le modèle
exclusif_content_types = Reward.content_types.select { |k, v| k.to_s.include?('_') && !k.to_s.start_with?('challenge_') }

exclusif_content_types.each do |key, value|
  puts "  - #{key}: #{value}"
end

puts "\n✅ Test terminé avec succès!"
puts "\n📝 Pour tester la page des récompenses exclusives:"
puts "   Visitez: /exclusif_rewards"
puts "   Ou utilisez le lien: exclusif_rewards_path"
