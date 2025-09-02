#!/usr/bin/env ruby

# Test des chemins d'assets pour les images ultimes
puts "🎯 Test des chemins d'assets pour les images ultimes"
puts "=" * 60

# Charger l'environnement Rails
require_relative 'config/environment'

# Inclure le helper
include ApplicationHelper

puts "\n🖼️ Test des chemins d'assets :"

# Tester asset_path pour chaque image
ultime_content_types = ['backstage_real', 'concert_invitation', 'vip_experience']

ultime_content_types.each do |content_type|
  puts "\n📁 #{content_type}:"
  
  case content_type
  when 'backstage_real'
    (1..4).each do |i|
      path = asset_path("rewards/ultime/backstage_real/backstage_concert_#{i}.jpg")
      puts "   #{i}. #{path}"
    end
  when 'concert_invitation'
    (1..4).each do |i|
      path = asset_path("rewards/ultime/concert_invitation/concert_stage_#{i}.jpg")
      puts "   #{i}. #{path}"
    end
  when 'vip_experience'
    (1..4).each do |i|
      path = asset_path("rewards/ultime/vip_experience/vip_meeting_#{i}.jpg")
      puts "   #{i}. #{path}"
    end
  end
end

puts "\n🎮 Test de la méthode helper :"
5.times do |i|
  image = get_ultime_preview_image
  puts "   Test #{i + 1}: #{image}"
end

puts "\n✅ Test terminé !"
puts "   Les chemins d'assets utilisent maintenant asset_path()"
puts "   Cela devrait résoudre le problème d'affichage des images"
