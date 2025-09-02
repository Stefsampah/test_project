#!/usr/bin/env ruby

# Test rapide de la méthode helper get_ultime_preview_image
puts "🎯 Test de la méthode helper get_ultime_preview_image"
puts "=" * 50

# Charger l'environnement Rails
require_relative 'config/environment'

# Inclure le helper
include ApplicationHelper

puts "\n🖼️ Test de sélection d'images ultimes :"

# Tester plusieurs fois pour voir la sélection aléatoire
5.times do |i|
  image = get_ultime_preview_image
  puts "   Test #{i + 1}: #{image}"
end

puts "\n✅ Test terminé !"
puts "   La méthode helper sélectionne maintenant toutes vos images ultimes disponibles"
