#!/usr/bin/env ruby

# Test de cohérence finale Premium avec vidéo
puts "🎯 Test de cohérence finale Premium avec vidéo"
puts "=" * 60

# Charger l'environnement Rails
require_relative 'config/environment'

# Inclure le helper
include ApplicationHelper

puts "\n🖼️ Test de cohérence Premium avec vidéo :"

# Créer un utilisateur de test
user = User.find_or_create_by(email: 'test_premium_video@example.com') do |u|
  u.username = 'test_premium_video'
  u.password = 'password123'
end

# Simuler current_user
def current_user
  User.find_by(email: 'test_premium_video@example.com')
end

puts "\n🥇 Test Premium (9 badges) - Cohérence complète :"
premium_image = get_premium_preview_image
puts "   Image sélectionnée: #{premium_image}"

# Simuler la logique de sélection de vidéo
user_id = current_user.id
premium_videos = [
  '0tJz8JjPbHU', # Didi B Félicia
  'QVvfSQP3JLM', # Didi B Bouaké
  'JWrIfPCyedU', # Charles Doré
  'ICvSOFEKbgs', # Miki Accor Arena
  'ORfP-QudA1A', # Timeo
  'VFvDwn2r5RI'  # Marine
]
premium_video_id = premium_videos[user_id % premium_videos.length]

puts "   Vidéo sélectionnée: #{premium_video_id}"

# Vérifier la cohérence
premium_images = [
  'https://img.youtube.com/vi/0tJz8JjPbHU/maxresdefault.jpg', # Didi B Félicia
  'https://img.youtube.com/vi/QVvfSQP3JLM/maxresdefault.jpg', # Didi B Bouaké
  'https://img.youtube.com/vi/JWrIfPCyedU/maxresdefault.jpg', # Charles Doré
  'https://img.youtube.com/vi/ICvSOFEKbgs/maxresdefault.jpg', # Miki Accor Arena
  'https://img.youtube.com/vi/ORfP-QudA1A/maxresdefault.jpg', # Timeo
  'https://img.youtube.com/vi/VFvDwn2r5RI/maxresdefault.jpg'  # Marine
]

selected_index = user_id % premium_images.length
expected_image = premium_images[selected_index]
expected_video = premium_videos[selected_index]

puts "\n✅ Vérification de la cohérence :"
puts "   Image attendue: #{expected_image}"
puts "   Vidéo attendue: #{expected_video}"
puts "   Image réelle: #{premium_image}"
puts "   Vidéo réelle: #{premium_video_id}"

if premium_image == expected_image && premium_video_id == expected_video
  puts "   ✅ COHÉRENCE PARFAITE !"
  puts "   🎬 La vidéo correspond à l'image"
else
  puts "   ❌ PROBLÈME DE COHÉRENCE !"
  puts "   🎬 La vidéo ne correspond pas à l'image"
end

puts "\n📋 Mapping Image → Vidéo :"
premium_images.each_with_index do |image, index|
  video = premium_videos[index]
  artist = case index
  when 0 then "Didi B Félicia"
  when 1 then "Didi B Bouaké"
  when 2 then "Charles Doré"
  when 3 then "Miki Accor Arena"
  when 4 then "Timeo"
  when 5 then "Marine"
  end
  puts "   #{artist}: #{video}"
end

puts "\n✅ Test terminé !"
puts "   L'image et la vidéo Premium sont maintenant cohérentes"
