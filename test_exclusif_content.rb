#!/usr/bin/env ruby

# Script de test pour vérifier les récompenses exclusives mises à jour
require_relative 'config/environment'

puts "🎯 Test des récompenses exclusives mises à jour"
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
if user.user_badges.count < 6
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
      b.image = 'star.png'
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
else
  puts "🎉 L'utilisateur a déjà #{user.user_badges.count} badges !"
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

puts "\n🎯 Types de contenu exclusif disponibles:"
puts "=" * 40

# Afficher les types de contenu exclusif spécifiés
exclusif_types = [
  'rapivoire_ci', 'my_afro_culture', 'baton_rouge_label', 'pan_african_music',
  'generation_voyage', 'pigeons_planes', 'bandcamp_daily', 'underground_ivoire',
  'le_type', 'radio_campus_france', 'la_souterraine', 'le_tournedisque',
  'didi_b_interview', 'himra_legendes_urbaines', 'zoh_cataleya_serge_dioman',
  'do_it_together', 'rumble_indians', 'country_music_ken_burns', 'rap_odyssees_france_tv',
  'himra_number_one_live', 'didi_b_nouvelle_generation', 'zoh_cataleya_live_toura',
  'bigyne_wiz_abe_sounogola', 'didi_b_mhd_studio', 'didi_b_naira_marley',
  'didi_b_enregistrement', 'werenoi_cstar_session', 'himra_top_boy_live',
  'timar_zz_lequel', 'octogone_philipayne'
]

exclusif_types.each do |content_type|
  if Reward.content_types.key?(content_type)
    puts "  ✅ #{content_type}"
  else
    puts "  ❌ #{content_type} (manquant)"
  end
end

puts "\n🎲 Test de la sélection aléatoire..."
puts "   Testons la sélection d'une récompense exclusive..."

# Tester la sélection aléatoire
selected_reward = Reward.select_random_reward(user, 'exclusif')
if selected_reward
  puts "   🎯 Récompense sélectionnée: #{selected_reward[:content_type]}"
  puts "   📝 Nom: #{selected_reward[:name]}"
  puts "   📖 Description: #{selected_reward[:description]}"
  puts "   🎨 Icône: #{selected_reward[:icon]}"
else
  puts "   ❌ Aucune récompense sélectionnée"
end

puts "\n✅ Test terminé avec succès!"
puts "\n📝 Pour tester les récompenses exclusives:"
puts "   1. Assurez-vous que votre serveur Rails est en cours d'exécution"
puts "   2. Ouvrez votre navigateur et connectez-vous avec admin@example.com"
puts "   3. Visitez: /exclusif_rewards"
puts "   4. Testez le déblocage des récompenses exclusives"
puts "   5. Cliquez sur une récompense pour voir ses détails"
puts "   6. Vérifiez que les liens externes fonctionnent correctement"
