#!/usr/bin/env ruby

# Script simple pour créer une récompense exclusive pour l'utilisateur existant
require_relative 'config/environment'

puts "🎁 Création d'une récompense exclusive pour l'utilisateur existant"
puts "=" * 60

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

# Créer directement une récompense exclusive
puts "\n🔓 Création d'une récompense exclusive..."

# Créer une récompense exclusive avec un contenu aléatoire
exclusif_content_types = [
  'rapivoire_ci', 'my_afro_culture', 'afrikactus', 'baton_rouge_label',
  'pan_african_music', 'generation_voyage', 'pigeons_planes', 'bandcamp_daily',
  'underground_ivoire', 'le_type', 'radio_campus_france', 'la_souterraine',
  'le_tournedisque', 'didi_b_interview', 'himra_legendes_urbaines',
  'zoh_cataleya_serge_dioman', 'do_it_together', 'rumble_indians',
  'country_music_ken_burns', 'rap_odyssees_france_tv', 'himra_number_one_live',
  'didi_b_nouvelle_generation', 'zoh_cataleya_live_toura', 'bigyne_wiz_abe_sounogola',
  'didi_b_mhd_studio', 'didi_b_naira_marley', 'didi_b_enregistrement',
  'werenoi_cstar_session', 'himra_top_boy_live', 'timar_zz_lequel', 'octogone_philipayne'
]

selected_content = exclusif_content_types.sample

# Créer la récompense
reward = Reward.create!(
  user: selected_user,
  reward_type: 'exclusif',
  content_type: selected_content,
  reward_description: "Contenu exclusif débloqué",
  quantity_required: 6,
  badge_type: 'unified',
  unlocked: true,
  unlocked_at: Time.current
)

puts "🎉 Récompense exclusive créée : #{selected_content}"

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
puts "   5. Vous devriez voir votre récompense exclusive débloquée"
