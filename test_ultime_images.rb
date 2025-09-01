#!/usr/bin/env ruby

puts "🖼️ TEST DES IMAGES RÉCOMPENSES ULTIMES"
puts "=" * 60

require_relative 'config/environment'

# Vérifier la structure des dossiers d'images
puts "\n📁 Vérification de la structure des dossiers d'images..."

ultime_images_path = Rails.root.join('app', 'assets', 'images', 'rewards', 'ultime')
puts "   Chemin principal : #{ultime_images_path}"

if Dir.exist?(ultime_images_path)
  puts "   ✅ Dossier principal trouvé"
  
  # Vérifier chaque sous-dossier
  subdirs = ['backstage_real', 'concert_invitation', 'vip_experience']
  
  subdirs.each do |subdir|
    subdir_path = ultime_images_path.join(subdir)
    if Dir.exist?(subdir_path)
      puts "   ✅ Dossier #{subdir} trouvé"
      
      # Lister les images dans le sous-dossier
      images = Dir.glob(subdir_path.join('*.{jpg,jpeg,png,gif}'))
      puts "   📸 Images trouvées : #{images.count}"
      
      images.each do |image|
        filename = File.basename(image)
        puts "      - #{filename}"
      end
    else
      puts "   ❌ Dossier #{subdir} manquant"
    end
  end
  
  # Vérifier les récompenses ultimes existantes
  puts "\n🏆 Vérification des récompenses ultimes existantes..."
  
  ultime_rewards = Reward.where(reward_type: 'ultime')
  puts "   Total récompenses ultimes : #{ultime_rewards.count}"
  
  if ultime_rewards.any?
    ultime_rewards.each do |reward|
      puts "\n   📋 Récompense ID: #{reward.id}"
      puts "      Content Type: #{reward.content_type}"
      puts "      Débloquée: #{reward.unlocked? ? 'Oui' : 'Non'}"
      
      # Tester la génération d'image selon le content_type
      case reward.content_type
      when 'backstage_real'
        puts "      🎭 Type: Backstage Réel"
        puts "      🖼️  Images disponibles: /assets/images/rewards/ultime/backstage_real/"
      when 'concert_invitation'
        puts "      🎫 Type: Invitation Concert"
        puts "      🖼️  Images disponibles: /assets/images/rewards/ultime/concert_invitation/"
      when 'vip_experience'
        puts "      🌟 Type: Expérience VIP"
        puts "      🖼️  Images disponibles: /assets/images/rewards/ultime/vip_experience/"
      else
        puts "      ❓ Type: #{reward.content_type} (non reconnu)"
      end
    end
  else
    puts "   ℹ️  Aucune récompense ultime trouvée dans la base de données"
  end
  
  # Tester la méthode helper
  puts "\n🔧 Test de la méthode helper get_ultime_preview_image..."
  begin
    helper = ApplicationController.helpers
    preview_image = helper.get_ultime_preview_image
    puts "   ✅ Helper fonctionne"
    puts "   🖼️  Image de prévisualisation: #{preview_image}"
  rescue => e
    puts "   ❌ Erreur helper: #{e.message}"
  end
  
  # Tester la méthode du contrôleur
  puts "\n🎮 Test de la méthode get_ultime_reward_images..."
  begin
    # Créer un utilisateur temporaire pour le test
    test_user = User.first
    if test_user
      controller = RewardsController.new
      controller.instance_variable_set(:@current_user, test_user)
      
      # Appeler la méthode privée via send
      ultime_images = controller.send(:get_ultime_reward_images)
      puts "   ✅ Méthode contrôleur fonctionne"
      puts "   🖼️  Images générées: #{ultime_images.count}"
      
      ultime_images.each do |reward_id, image_path|
        puts "      Récompense #{reward_id}: #{image_path}"
      end
    else
      puts "   ℹ️  Aucun utilisateur trouvé pour le test"
    end
  rescue => e
    puts "   ❌ Erreur contrôleur: #{e.message}"
  end
  
  puts "\n✅ Test des images terminé avec succès !"
  puts "\n📝 Prochaines étapes :"
  puts "   1. Vérifiez que toutes vos images sont bien placées"
  puts "   2. Testez l'interface utilisateur"
  puts "   3. Vérifiez que les galeries s'ouvrent correctement"
  
else
  puts "   ❌ Dossier principal non trouvé"
  puts "   📁 Créez le dossier : #{ultime_images_path}"
end
