#!/usr/bin/env ruby

# Script pour ajouter 6 badges à un utilisateur
# Permet de tester les récompenses exclusives

require_relative 'config/environment'

puts "🎯 Ajout de badges pour tester les récompenses exclusives"
puts "=" * 60

# Trouver l'utilisateur admin
user = User.find_by(email: 'admin@example.com')

if user.nil?
  puts "❌ Utilisateur admin@example.com non trouvé"
  puts "   Créons un utilisateur admin..."
  
  user = User.create!(
    email: 'admin@example.com',
    password: '123456',
    password_confirmation: '123456',
    username: 'admin'
  )
  
  puts "✅ Utilisateur admin créé avec succès"
else
  puts "✅ Utilisateur trouvé: #{user.email}"
end

puts "\n🏅 Badges actuels: #{user.user_badges.count}"

# Vérifier si l'utilisateur a déjà 6 badges
if user.user_badges.count >= 6
  puts "🎉 L'utilisateur a déjà #{user.user_badges.count} badges !"
  puts "   Il peut accéder aux récompenses exclusives."
else
  puts "\n🔧 Ajout de badges pour atteindre 6 badges..."
  
  # Créer des badges de test si nécessaire
  badges_to_add = 6 - user.user_badges.count
  
  badges_to_add.times do |i|
    badge_number = user.user_badges.count + i + 1
    badge_type = case badge_number
                 when 1..2 then 'bronze'
                 when 3..4 then 'silver'
                 else 'gold'
                 end
    
    badge_name = "test_badge_#{badge_number}"
    
    badge = Badge.find_or_create_by!(badge_type: badge_name) do |b|
      b.title = "Badge Test #{badge_type.capitalize} #{badge_number}"
      b.description = "Badge de test pour les récompenses exclusives"
      b.points = 100
      b.level = badge_type
      b.reward_type = 'standard'
      b.reward_description = 'Badge de test'
      b.image = 'star.png' # Image par défaut
    end
    
    # Attribuer le badge à l'utilisateur
    unless user.user_badges.exists?(badge: badge)
      UserBadge.create!(
        user: user,
        badge: badge,
        earned_at: Time.current
      )
      
      puts "  ✅ Badge #{badge_type.capitalize} #{badge_number} créé et attribué"
    else
      puts "  ℹ️ Badge #{badge_type.capitalize} #{badge_number} déjà attribué"
    end
  end
end

puts "\n🏅 Badges après ajout: #{user.user_badges.count}"

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

puts "\n🎯 Test de la sélection aléatoire des récompenses exclusives..."
puts "Types de contenu disponibles pour les récompenses exclusives:"

# Récupérer les types de contenu exclusif depuis le modèle
exclusif_content_types = Reward.content_types.select { |k, v| k.to_s.include?('_') && !k.to_s.start_with?('challenge_') }

exclusif_content_types.each do |key, value|
  puts "  - #{key}: #{value}"
end

puts "\n✅ Script terminé avec succès!"
puts "\n📝 Pour tester les récompenses exclusives:"
puts "   1. Assurez-vous que votre serveur Rails est en cours d'exécution"
puts "   2. Ouvrez votre navigateur et connectez-vous avec admin@example.com"
puts "   3. Visitez: /exclusif_rewards"
puts "   4. Testez le déblocage des récompenses exclusives"
puts "   5. Cliquez sur une récompense pour voir ses détails"
