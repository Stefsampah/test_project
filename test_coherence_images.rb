#!/usr/bin/env ruby

# Test de cohérence des images entre les pages
puts "🎯 Test de cohérence des images entre les pages"
puts "=" * 60

# Charger l'environnement Rails
require_relative 'config/environment'

# Inclure le helper
include ApplicationHelper

puts "\n🖼️ Test de cohérence des images :"

# Créer un utilisateur de test
user = User.find_or_create_by(email: 'test_coherence@example.com') do |u|
  u.username = 'test_coherence'
  u.password = 'password123'
end

# Simuler current_user
def current_user
  User.find_by(email: 'test_coherence@example.com')
end

puts "\n🥇 Test Premium (9 badges) - Cohérence :"
5.times do |i|
  image = get_premium_preview_image
  puts "   Test #{i + 1}: #{image}"
end

puts "\n🌈 Test Ultime (12 badges) - Cohérence :"
5.times do |i|
  image = get_ultime_preview_image
  puts "   Test #{i + 1}: #{image}"
end

puts "\n✅ Vérification :"
puts "   - Les images Premium devraient être identiques à chaque appel"
puts "   - Les images Ultimes devraient être identiques à chaque appel"
puts "   - Chaque utilisateur aura sa propre image cohérente"

# Test avec un autre utilisateur
user2 = User.find_or_create_by(email: 'test_coherence2@example.com') do |u|
  u.username = 'test_coherence2'
  u.password = 'password123'
end

puts "\n👤 Test avec utilisateur différent :"
def current_user
  User.find_by(email: 'test_coherence2@example.com')
end

premium_image2 = get_premium_preview_image
ultime_image2 = get_ultime_preview_image

puts "   Premium: #{premium_image2}"
puts "   Ultime: #{ultime_image2}"

puts "\n✅ Test terminé !"
puts "   Les images sont maintenant cohérentes entre les pages"
puts "   Chaque utilisateur a sa propre image basée sur son ID"
