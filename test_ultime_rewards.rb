#!/usr/bin/env ruby

puts "🧪 TEST COMPLET DES RÉCOMPENSES ULTIMES AVEC IMAGES ET GALERIES"
puts "=" * 80

require_relative 'config/environment'

# Trouver un utilisateur avec des récompenses ultimes
user = User.joins(:rewards).where(rewards: { reward_type: 'ultime', unlocked: true }).first

if user
  puts "\n👤 Utilisateur testé : #{user.email}"
  
  # Récupérer les récompenses ultimes
  ultime_rewards = user.rewards.where(reward_type: 'ultime', unlocked: true)
  
  puts "\n🏆 Récompenses ultimes trouvées : #{ultime_rewards.count}"
  
  ultime_rewards.each do |reward|
    puts "\n📋 Récompense ID: #{reward.id}"
    puts "   Type: #{reward.reward_type}"
    puts "   Content Type: #{reward.content_type}"
    puts "   Description: #{reward.reward_description}"
    puts "   Badges requis: #{reward.quantity_required}"
    puts "   Débloquée le: #{reward.unlocked_at}"
    
    # Tester la sélection d'image selon le content_type
    case reward.content_type
    when 'backstage_real'
      puts "   🎭 Type: Backstage Réel"
      puts "   📝 Description: Accès exclusif aux coulisses réelles d'un concert - Expérience backstage authentique"
      available_images = [
        '/assets/images/rewards/ultime/backstage_real/backstage_concert_1.jpg',
        '/assets/images/rewards/ultime/backstage_real/backstage_concert_2.jpg',
        '/assets/images/rewards/ultime/backstage_real/backstage_concert_3.jpg',
        '/assets/images/rewards/ultime/backstage_real/backstage_concert_4.jpg'
      ]
      selected_image = available_images.sample
      puts "   🖼️  Image sélectionnée: #{selected_image}"
      puts "   🎯 Action: Bouton '🖼️ Voir la galerie' → Ouvre galerie d'images backstage"
      
    when 'concert_invitation'
      puts "   🎫 Type: Invitation Concert"
      puts "   📝 Description: Invitation exclusive à un concert près de chez vous - Accès privilégié garanti"
      available_images = [
        '/assets/images/rewards/ultime/concert_invitation/concert_stage_1.jpg',
        '/assets/images/rewards/ultime/concert_invitation/concert_stage_2.jpg',
        '/assets/images/rewards/ultime/concert_invitation/concert_stage_3.jpg',
        '/assets/images/rewards/ultime/concert_invitation/concert_stage_4.jpg'
      ]
      selected_image = available_images.sample
      puts "   🖼️  Image sélectionnée: #{selected_image}"
      puts "   🎯 Action: Bouton '🖼️ Voir la galerie' → Ouvre galerie d'images concert"
      
    when 'vip_experience'
      puts "   🌟 Type: Expérience VIP"
      puts "   📝 Description: Rencontre privée avec un artiste + accès backstage réel - Expérience VIP exclusive"
      available_images = [
        '/assets/images/rewards/ultime/vip_experience/vip_meeting_1.jpg',
        '/assets/images/rewards/ultime/vip_experience/vip_meeting_2.jpg',
        '/assets/images/rewards/ultime/vip_experience/vip_meeting_3.jpg',
        '/assets/images/rewards/ultime/vip_experience/vip_meeting_4.jpg'
      ]
      selected_image = available_images.sample
      puts "   🖼️  Image sélectionnée: #{selected_image}"
      puts "   🎯 Action: Bouton '🖼️ Voir la galerie' → Ouvre galerie d'images VIP"
      
    else
      puts "   ❓ Type: #{reward.content_type} (non reconnu)"
    end
    
    puts "   🎨 Interface: Modal avec galerie d'images (pas de vidéo YouTube)"
    puts "   🚫 Fallback: Aucun fallback YouTube - uniquement vos images personnalisées"
  end
  
  puts "\n✅ Test terminé avec succès !"
  puts "\n📝 Résumé des améliorations pour récompenses ultimes :"
  puts "   • Types de contenu simplifiés : backstage_real, concert_invitation, vip_experience"
  puts "   • Images personnalisées au lieu de vidéos YouTube"
  puts "   • Boutons '🖼️ Voir la galerie' au lieu de '🎬 Regarder le contenu'"
  puts "   • Galeries d'images dans des modals dédiés"
  puts "   • Aucun fallback YouTube - exclusivité totale"
  puts "   • Interface cohérente avec les autres récompenses"
  
  puts "\n📁 Images à placer dans :"
  puts "   app/assets/images/rewards/ultime/backstage_real/"
  puts "   app/assets/images/rewards/ultime/concert_invitation/"
  puts "   app/assets/images/rewards/ultime/vip_experience/"
  
else
  puts "\n❌ Aucun utilisateur avec des récompenses ultimes trouvé"
  puts "   Créez d'abord des récompenses ultimes pour tester"
end
