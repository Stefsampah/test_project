#!/usr/bin/env ruby

# Script pour configurer les récompenses exclusives pour l'utilisateur existant
require_relative 'config/environment'

puts "🔧 Configuration des récompenses exclusives pour l'utilisateur existant"
puts "=" * 70

# Lister tous les utilisateurs
puts "👥 Utilisateurs disponibles:"
users = User.all
users.each_with_index do |user, index|
  puts "   #{index + 1}. #{user.email} (ID: #{user.id}) - Badges: #{user.user_badges.count}"
end

# Demander quel utilisateur configurer
puts "\n🎯 Quel utilisateur voulez-vous configurer ?"
puts "   Entrez le numéro (1, 2, 3...) ou l'email:"
user_input = gets.chomp

selected_user = nil

# Essayer de trouver l'utilisateur
if user_input.match?(/^\d+$/)
  index = user_input.to_i - 1
  if index >= 0 && index < users.count
    selected_user = users[index]
  end
else
  selected_user = User.find_by(email: user_input)
end

if selected_user.nil?
  puts "❌ Utilisateur non trouvé"
  exit 1
end

puts "\n✅ Utilisateur sélectionné: #{selected_user.email}"
puts "🏅 Badges actuels: #{selected_user.user_badges.count}"

# Vérifier si l'utilisateur a déjà des récompenses exclusives
puts "\n📊 Récompenses existantes:"
all_rewards = selected_user.rewards
puts "   Total: #{all_rewards.count}"

if all_rewards.any?
  all_rewards.each do |reward|
    puts "   - #{reward.reward_type}: #{reward.content_type} (unlocked: #{reward.unlocked})"
  end
else
  puts "   Aucune récompense"
end

# Vérifier les récompenses exclusives
puts "\n⭐ Récompenses exclusives:"
exclusif_rewards = selected_user.rewards.where(reward_type: 'exclusif')
puts "   Total: #{exclusif_rewards.count}"

if exclusif_rewards.any?
  exclusif_rewards.each do |reward|
    puts "   - #{reward.content_type}: #{reward.reward_description} (unlocked: #{reward.unlocked})"
  end
else
  puts "   Aucune récompense exclusive"
end

# Si l'utilisateur n'a pas 6 badges, en ajouter
if selected_user.user_badges.count < 6
  puts "\n🔧 Ajout de badges pour atteindre 6 badges..."
  
  badges_to_add = 6 - selected_user.user_badges.count
  
  badges_to_add.times do |i|
    badge_number = selected_user.user_badges.count + i + 1
    badge_type = case badge_number
                 when 1..2 then 'bronze'
                 when 3..4 then 'silver'
                 else 'gold'
                 end
    
    # Utiliser un type de badge valide selon le modèle
    valid_badge_type = case i % 4
                       when 0 then 'competitor'
                       when 1 then 'engager'
                       when 2 then 'critic'
                       else 'challenger'
                       end
    
    badge_name = "#{valid_badge_type}_#{badge_type}_#{badge_number}"
    
    badge = Badge.find_or_create_by!(badge_type: badge_name) do |b|
      b.name = "Badge Utilisateur #{badge_type.capitalize} #{badge_number}"
      b.description = "Badge pour les récompenses exclusives"
      b.points_required = 100
      b.level = badge_type
      b.reward_type = 'standard'
      b.reward_description = 'Badge utilisateur'
      b.image = 'star.png'
    end
    
    # Attribuer le badge à l'utilisateur
    unless selected_user.user_badges.exists?(badge: badge)
      UserBadge.create!(
        user: selected_user,
        badge: badge,
        earned_at: Time.current
      )
      
      puts "  ✅ Badge #{badge_type.capitalize} #{badge_number} créé et attribué"
    else
      puts "  ℹ️ Badge #{badge_type.capitalize} #{badge_number} déjà attribué"
    end
  end
else
  puts "🎉 L'utilisateur a déjà #{selected_user.user_badges.count} badges !"
end

puts "\n🏅 Badges après ajout: #{selected_user.user_badges.count}"

# Créer des récompenses exclusives
puts "\n🔓 Création de récompenses exclusives..."
new_rewards = Reward.check_and_create_rewards_for_user(selected_user)

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
exclusif_rewards = selected_user.rewards.where(reward_type: 'exclusif')
if exclusif_rewards.any?
  exclusif_rewards.each do |reward|
    puts "  - #{reward.content_type}: #{reward.reward_description}"
  end
else
  puts "  Aucune récompense exclusive"
end

puts "\n✅ Configuration terminée avec succès!"
puts "\n📝 Pour tester les récompenses exclusives:"
puts "   1. Assurez-vous que votre serveur Rails est en cours d'exécution"
puts "   2. Ouvrez votre navigateur et connectez-vous avec #{selected_user.email}"
puts "   3. Visitez: /exclusif_rewards"
puts "   4. La page devrait maintenant se charger sans erreur"
puts "   5. Vous devriez voir vos récompenses exclusives débloquées"
