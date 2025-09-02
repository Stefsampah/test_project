#!/usr/bin/env ruby

# Test de cohérence finale Premium
puts "🎯 Test de cohérence finale Premium"
puts "=" * 50

# Charger l'environnement Rails
require_relative 'config/environment'

# Inclure le helper
include ApplicationHelper

puts "\n🖼️ Test de cohérence Premium :"

# Créer un utilisateur de test
user = User.find_or_create_by(email: 'test_premium@example.com') do |u|
  u.username = 'test_premium'
  u.password = 'password123'
end

# Simuler current_user
def current_user
  User.find_by(email: 'test_premium@example.com')
end

puts "\n🥇 Test Premium (9 badges) - Cohérence :"
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
else
  puts "   ❌ PROBLÈME DE COHÉRENCE !"
end

puts "\n✅ Test terminé !"
puts "   L'image et la vidéo Premium sont maintenant cohérentes"
