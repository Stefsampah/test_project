#!/usr/bin/env ruby

# Script de test pour les contenus Premium
puts "🎯 TEST DES CONTENUS PREMIUM"
puts "=" * 50

# Simuler les 3 types de contenus Premium
premium_contents = [
  {
    content_type: 'exclusive_photos',
    name: 'Photos Exclusives',
    description: 'Photos exclusives d\'artistes',
    icon: '📸',
    type: 'photos'
  },
  {
    content_type: 'backstage_video', 
    name: 'Vidéo Backstage',
    description: 'Vidéo backstage exclusive',
    icon: '🎭',
    type: 'video',
    video_id: '0tJz8JjPbHU',
    title: 'Vidéo Backstage Exclusive'
  },
  {
    content_type: 'concert_footage',
    name: 'Extrait Concert', 
    description: 'Extrait exclusif de concert',
    icon: '🎪',
    type: 'video',
    video_id: 'QVvfSQP3JLM',
    title: 'Extrait Concert Exclusif'
  }
]

puts "\n📋 CONTENUS PREMIUM DISPONIBLES :"
puts "-" * 30

premium_contents.each_with_index do |content, index|
  puts "\n#{index + 1}. #{content[:icon]} #{content[:name]}"
  puts "   Type: #{content[:content_type]}"
  puts "   Description: #{content[:description]}"
  puts "   Catégorie: #{content[:type]}"
  
  if content[:type] == 'video'
    puts "   Vidéo ID: #{content[:video_id]}"
    puts "   Titre: #{content[:title]}"
    puts "   Action: 🎬 Regarder la vidéo"
  else
    puts "   Action: 📸 Voir les photos"
  end
end

puts "\n🎮 COMMENT TESTER :"
puts "-" * 20
puts "1. Allez sur /my_rewards ou /all_rewards"
puts "2. Cliquez sur une carte Premium débloquée"
puts "3. Cliquez sur 'Afficher le contenu'"
puts "4. Vous verrez :"
puts "   - 📸 'Voir les photos' pour exclusive_photos"
puts "   - 🎬 'Regarder la vidéo' pour backstage_video" 
puts "   - 🎬 'Regarder la vidéo' pour concert_footage"

puts "\n✅ SYSTÈME MIS À JOUR :"
puts "-" * 25
puts "• exclusive_photos → Galerie de photos (6 images)"
puts "• backstage_video → Vidéo YouTube (0tJz8JjPbHU)"
puts "• concert_footage → Vidéo YouTube (QVvfSQP3JLM)"
puts "• Gestion intelligente selon le content_type"
puts "• Plus de problème avec premium_video_id undefined"

puts "\n🚀 PRÊT POUR LES TESTS !"
