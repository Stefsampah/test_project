#!/usr/bin/env ruby

puts "🧹 Nettoyage des récompenses génériques et unification du système"
puts "=" * 60

# Charger l'environnement Rails
require_relative 'config/environment'

# 1. Identifier les récompenses génériques (content_type vide ou null)
generic_rewards = Reward.where("content_type IS NULL OR content_type = '' OR content_type = 'null'")
puts "\n🔍 Récompenses génériques trouvées : #{generic_rewards.count}"

if generic_rewards.any?
  generic_rewards.each do |reward|
    puts "  - ID: #{reward.id} | User: #{reward.user.email} | Type: #{reward.reward_type} | Content: '#{reward.content_type}'"
  end
  
  # 2. Remplacer les récompenses génériques par des récompenses spécifiques
  puts "\n🔄 Remplacement des récompenses génériques..."
  
  generic_rewards.group_by(&:user).each do |user, rewards|
    puts "\n👤 Traitement de #{user.email} :"
    
    rewards.each do |reward|
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
      
      # Mettre à jour la récompense
      old_content_type = reward.content_type
      reward.update!(
        content_type: new_content_type,
        reward_description: generate_reward_description(reward.badge_type, reward.quantity_required, reward.reward_type, 'unified')
      )
      
      puts "  ✅ ID #{reward.id}: '#{old_content_type}' → '#{new_content_type}'"
    end
  end
else
  puts "  ℹ️  Aucune récompense générique à nettoyer"
end

# 3. Vérifier les doublons potentiels
puts "\n🔍 Vérification des doublons..."
User.all.each do |user|
  user.rewards.group_by(&:reward_type).each do |reward_type, rewards|
    if rewards.count > 1
      puts "  ⚠️  #{user.email} a #{rewards.count} récompenses #{reward_type}"
      rewards.each do |reward|
        puts "    - ID: #{reward.id} | Content: #{reward.content_type}"
      end
    end
  end
end

# 4. Statistiques finales
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

puts "\n✅ Nettoyage terminé !"
puts "🎯 Le système de récompenses est maintenant unifié et cohérent."
puts "📝 Toutes les récompenses ont maintenant un content_type spécifique."

# Méthode helper pour générer les descriptions
def generate_reward_description(badge_type, quantity, reward_type, category)
  case reward_type
  when 'challenge'
    "#{quantity} badges - Accès anticipé à des playlists + codes promo exclusifs"
  when 'exclusif'
    "#{quantity} badges - Photos dédicacées d'artistes + contenu exclusif"
  when 'premium'
    "#{quantity} badges - Rencontres avec des artistes + accès backstage virtuel"
  when 'ultime'
    "#{quantity} badges - Rencontre privée avec un artiste + accès backstage réel"
  end
end
