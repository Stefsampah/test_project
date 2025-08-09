#!/usr/bin/env ruby

puts "🧹 Nettoyage final des récompenses génériques restantes"
puts "=" * 55

# Charger l'environnement Rails
require_relative 'config/environment'

# Identifier toutes les récompenses génériques restantes
generic_rewards = Reward.where("content_type IS NULL OR content_type = '' OR content_type = 'null'")

puts "\n🔍 Récompenses génériques restantes : #{generic_rewards.count}"

if generic_rewards.any?
  generic_rewards.each do |reward|
    user = reward.user
    puts "\n👤 Traitement de #{user.email} - ID: #{reward.id} (#{reward.reward_type})"
    
    # Déterminer le content_type approprié selon le reward_type
    new_content_type = case reward.reward_type
    when 'challenge'
      # Sélectionner une playlist challenge aléatoire
      available_playlists = [
        'challenge_reward_playlist_1', 'challenge_reward_playlist_2', 'challenge_reward_playlist_3',
        'challenge_reward_playlist_4', 'challenge_reward_playlist_5', 'challenge_reward_playlist_6',
        'challenge_reward_playlist_7', 'challenge_reward_playlist_8', 'challenge_reward_playlist_9',
        'challenge_reward_playlist_10', 'challenge_reward_playlist_11', 'challenge_reward_playlist_12',
        'challenge_reward_playlist_13', 'challenge_reward_playlist_14', 'challenge_reward_playlist_15'
      ]
      
      # Vérifier quelles playlists l'utilisateur a déjà
      existing_content_types = user.rewards.where("content_type LIKE ?", "challenge_reward_playlist%").pluck(:content_type)
      available_playlists = available_playlists - existing_content_types
      
      if available_playlists.empty?
        'challenge_reward_playlist_1' # Fallback
      else
        available_playlists.sample
      end
      
    when 'exclusif'
      ['podcast_exclusive', 'blog_article', 'documentary'].sample
    when 'premium'
      ['exclusive_photos', 'backstage_video'].sample
    when 'ultime'
      ['personal_voice_message', 'dedicated_photo'].sample
    else
      'playlist_exclusive' # Fallback
    end
    
    # Générer la description appropriée
    new_description = case reward.reward_type
    when 'challenge'
      "#{reward.quantity_required} badges - Accès anticipé à des playlists + codes promo exclusifs"
    when 'exclusif'
      "#{reward.quantity_required} badges - Photos dédicacées d'artistes + contenu exclusif"
    when 'premium'
      "#{reward.quantity_required} badges - Rencontres avec des artistes + accès backstage virtuel"
    when 'ultime'
      "#{reward.quantity_required} badges - Rencontre privée avec un artiste + accès backstage réel"
    else
      "Récompense #{reward.reward_type.humanize}"
    end
    
    # Mettre à jour la récompense
    old_content_type = reward.content_type
    reward.update!(
      content_type: new_content_type,
      reward_description: new_description
    )
    
    puts "  ✅ ID #{reward.id}: '#{old_content_type}' → '#{new_content_type}'"
  end
else
  puts "  ✅ Aucune récompense générique restante !"
end

# Vérification finale
puts "\n🔍 Vérification finale..."
User.all.each do |user|
  generic_rewards = user.rewards.where("content_type IS NULL OR content_type = '' OR content_type = 'null'")
  if generic_rewards.any?
    puts "  ⚠️  #{user.email} a encore #{generic_rewards.count} récompenses génériques"
  else
    puts "  ✅ #{user.email} : toutes les récompenses ont un content_type"
  end
end

# Statistiques finales
puts "\n📊 Statistiques finales :"
User.all.each do |user|
  total_rewards = user.rewards.count
  challenge_rewards = user.rewards.where(reward_type: 'challenge').count
  exclusif_rewards = user.rewards.where(reward_type: 'exclusif').count
  premium_rewards = user.rewards.where(reward_type: 'premium').count
  ultime_rewards = user.rewards.where(reward_type: 'ultime').count
  
  puts "  👤 #{user.email}:"
  puts "    - Total: #{total_rewards} récompenses"
  puts "    - Challenge: #{challenge_rewards}"
  puts "    - Exclusif: #{exclusif_rewards}"
  puts "    - Premium: #{premium_rewards}"
  puts "    - Ultime: #{ultime_rewards}"
end

puts "\n✅ Nettoyage final terminé !"
puts "🎯 Toutes les récompenses ont maintenant un content_type obligatoire."
puts "🚀 Le système est maintenant 100% unifié et prêt pour les tests !"
