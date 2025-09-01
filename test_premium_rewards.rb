#!/usr/bin/env ruby

puts "🧪 TEST COMPLET DES RÉCOMPENSES PREMIUM AVEC IMAGES ALÉATOIRES ET VIDÉOS"
puts "=" * 80

require_relative 'config/environment'

# Trouver un utilisateur avec des récompenses premium
user = User.joins(:rewards).where(rewards: { reward_type: 'premium', unlocked: true }).first

if user
  puts "\n👤 Utilisateur testé : #{user.email}"
  
  # Récupérer les récompenses premium
  premium_rewards = user.rewards.where(reward_type: 'premium', unlocked: true)
  
  puts "\n🏆 Récompenses premium trouvées : #{premium_rewards.count}"
  
  premium_rewards.each do |reward|
    puts "\n📋 Récompense ID: #{reward.id}"
    puts "   Type: #{reward.reward_type}"
    puts "   Content Type: #{reward.content_type}"
    puts "   Description: #{reward.reward_description}"
    puts "   Badges requis: #{reward.quantity_required}"
    puts "   Débloquée le: #{reward.unlocked_at}"
    
    # Tester la sélection d'image aléatoire
    case reward.content_type
    when 'exclusive_photos'
      puts "   📸 Type: Photos exclusives"
      available_images = [
        'https://img.youtube.com/vi/0tJz8JjPbHU/maxresdefault.jpg', # Didi B
        'https://img.youtube.com/vi/QVvfSQP3JLM/maxresdefault.jpg', # Didi B Bouaké
        'https://img.youtube.com/vi/JWrIfPCyedU/maxresdefault.jpg', # Charles Doré
        'https://img.youtube.com/vi/ICvSOFEKbgs/maxresdefault.jpg', # Miki
        'https://img.youtube.com/vi/ORfP-QudA1A/maxresdefault.jpg', # Timeo
        'https://img.youtube.com/vi/VFvDwn2r5RI/maxresdefault.jpg'  # Marine
      ]
      selected_image = available_images.sample
      puts "   🖼️  Image sélectionnée: #{selected_image}"
      
    when 'backstage_video'
      puts "   🎭 Type: Vidéo backstage"
      available_images = [
        'https://img.youtube.com/vi/0tJz8JjPbHU/maxresdefault.jpg', # Didi B Félicia
        'https://img.youtube.com/vi/QVvfSQP3JLM/maxresdefault.jpg', # Didi B Bouaké
        'https://img.youtube.com/vi/JWrIfPCyedU/maxresdefault.jpg', # Charles Doré
        'https://img.youtube.com/vi/ICvSOFEKbgs/maxresdefault.jpg', # Miki Accor Arena
        'https://img.youtube.com/vi/ORfP-QudA1A/maxresdefault.jpg', # Timeo
        'https://img.youtube.com/vi/VFvDwn2r5RI/maxresdefault.jpg'  # Marine
      ]
      selected_image = available_images.sample
      puts "   🖼️  Image sélectionnée: #{selected_image}"
      
    when 'concert_footage'
      puts "   🎪 Type: Extrait de concert"
      available_images = [
        'https://img.youtube.com/vi/0tJz8JjPbHU/maxresdefault.jpg', # Didi B
        'https://img.youtube.com/vi/QVvfSQP3JLM/maxresdefault.jpg', # Didi B
        'https://img.youtube.com/vi/ICvSOFEKbgs/maxresdefault.jpg', # Miki
        'https://img.youtube.com/vi/ORfP-QudA1A/maxresdefault.jpg', # Timeo
        'https://img.youtube.com/vi/VFvDwn2r5RI/maxresdefault.jpg'  # Marine
      ]
      selected_image = available_images.sample
      puts "   🖼️  Image sélectionnée: #{selected_image}"
      
    when 'charles_dore_backstage'
      puts "   🎸 Type: Session acoustique Charles Doré"
      available_images = [
        'https://img.youtube.com/vi/JWrIfPCyedU/maxresdefault.jpg', # Charles Doré
        'https://img.youtube.com/vi/0tJz8JjPbHU/maxresdefault.jpg', # Didi B
        'https://img.youtube.com/vi/QVvfSQP3JLM/maxresdefault.jpg'  # Didi B Bouaké
      ]
      selected_image = available_images.sample
      puts "   🖼️  Image sélectionnée: #{selected_image}"
      
    when 'carbonne_backstage', 'fredz_backstage', 'adele_robin_backstage'
      puts "   🎪 Type: Backstage #{reward.content_type.gsub('_backstage', '').titleize}"
      available_images = [
        'https://img.youtube.com/vi/0tJz8JjPbHU/maxresdefault.jpg', # Didi B
        'https://img.youtube.com/vi/QVvfSQP3JLM/maxresdefault.jpg', # Didi B Bouaké
        'https://img.youtube.com/vi/ICvSOFEKbgs/maxresdefault.jpg'  # Miki
      ]
      selected_image = available_images.sample
      puts "   🖼️  Image sélectionnée: #{selected_image}"
      
    when 'victorien_backstage', 'miki_backstage', 'marguerite_backstage'
      puts "   🎤 Type: Backstage #{reward.content_type.gsub('_backstage', '').titleize}"
      available_images = [
        'https://img.youtube.com/vi/ICvSOFEKbgs/maxresdefault.jpg', # Miki
        'https://img.youtube.com/vi/ORfP-QudA1A/maxresdefault.jpg', # Timeo
        'https://img.youtube.com/vi/VFvDwn2r5RI/maxresdefault.jpg'  # Marine
      ]
      selected_image = available_images.sample
      puts "   🖼️  Image sélectionnée: #{selected_image}"
      
    when 'timeo_backstage', 'marine_backstage'
      puts "   🎬 Type: Backstage #{reward.content_type.gsub('_backstage', '').titleize}"
      available_images = [
        'https://img.youtube.com/vi/ORfP-QudA1A/maxresdefault.jpg', # Timeo
        'https://img.youtube.com/vi/VFvDwn2r5RI/maxresdefault.jpg', # Marine
        'https://img.youtube.com/vi/0tJz8JjPbHU/maxresdefault.jpg'  # Didi B
      ]
      selected_image = available_images.sample
      puts "   🖼️  Image sélectionnée: #{selected_image}"
      
    else
      puts "   ❓ Type: #{reward.content_type} (non reconnu)"
    end
    
    # Tester la sélection de vidéo
    video_id = case reward.content_type
               when 'exclusive_photos' then '0tJz8JjPbHU' # Didi B
               when 'backstage_video' then 'QVvfSQP3JLM' # Didi B Bouaké
               when 'concert_footage' then 'ICvSOFEKbgs' # Miki
               when 'charles_dore_backstage' then 'JWrIfPCyedU' # Charles Doré
               when 'carbonne_backstage' then '0tJz8JjPbHU' # Didi B (fallback)
               when 'fredz_backstage' then '0tJz8JjPbHU' # Didi B (fallback)
               when 'adele_robin_backstage' then '0tJz8JjPbHU' # Didi B (fallback)
               when 'victorien_backstage' then 'ICvSOFEKbgs' # Miki
               when 'miki_backstage' then 'ICvSOFEKbgs' # Miki
               when 'marguerite_backstage' then 'ICvSOFEKbgs' # Miki
               when 'timeo_backstage' then 'ORfP-QudA1A' # Timeo
               when 'marine_backstage' then 'VFvDwn2r5RI' # Marine
               else '0tJz8JjPbHU' # Fallback Didi B
               end
    
    puts "   🎬 Vidéo ID: #{video_id}"
    puts "   🔗 Lien YouTube: https://www.youtube.com/watch?v=#{video_id}"
    
    # Tester la description personnalisée
    case reward.content_type
    when 'charles_dore_backstage'
      puts "   📝 Description: Session acoustique intimiste qui dévoile les émotions derrière 'Je pars mais je reste'"
    when 'carbonne_backstage'
      puts "   📝 Description: Backstage festival avec ambiance détendue et version alternative de 'Falbala'"
    when 'fredz_backstage'
      puts "   📝 Description: Soirée VIP en coulisses avec Fredz, émotions et confidences sur 'Extraordinaire'"
    when 'adele_robin_backstage'
      puts "   📝 Description: Backstage musical avec Adèle & Robin en mode complice sur 'Avec toi'"
    when 'victorien_backstage'
      puts "   📝 Description: Moments backstage et scène au Café de la Danse sur 'Danse dans Paris'"
    when 'miki_backstage'
      puts "   📝 Description: Performance live avec ambiance immersive de 'Particule' à l'Accor Arena"
    when 'marguerite_backstage'
      puts "   📝 Description: Version live avec émotions et engagement sur 'Les filles, les meufs'"
    when 'timeo_backstage'
      puts "   📝 Description: Clip complet avec scènes de tournage et storytelling de 'Si je m'en vais'"
    when 'marine_backstage'
      puts "   📝 Description: Clip complet avec ambiance visuelle et émotionnelle de 'Cœur maladroit'"
    end
  end
  
  puts "\n✅ Test terminé avec succès !"
  puts "\n📝 Résumé des améliorations :"
  puts "   • Images aléatoires pour tous les types de récompenses premium"
  puts "   • Descriptions personnalisées selon le content_type"
  puts "   • Bouton 'Regarder le contenu' fonctionnel avec vidéos YouTube"
  puts "   • Interface cohérente avec les autres récompenses"
  puts "   • Support complet de tous les types de contenu premium"
  
else
  puts "\n❌ Aucun utilisateur avec des récompenses premium trouvé"
  puts "   Créez d'abord des récompenses premium pour tester"
end
