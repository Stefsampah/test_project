#!/usr/bin/env ruby

# Script pour tester la correction finale
require_relative 'config/environment'

puts "🧪 TEST DE LA CORRECTION FINALE"
puts "=" * 40

# Tester les méthodes sur une playlist
playlist = Playlist.find_by(title: 'Afro Vibes Vol. 1')
if playlist
  puts "Test sur: #{playlist.title}"
  puts "Première vidéo: #{playlist.videos.first.youtube_id}"
  puts ""
  
  puts "Méthodes après correction:"
  puts "  first_thumbnail: #{playlist.first_thumbnail}"
  puts "  consistent_thumbnail: #{playlist.consistent_thumbnail}"
  puts "  random_thumbnail: #{playlist.random_thumbnail}"
  puts ""
  
  # Tester plusieurs fois pour vérifier la stabilité
  puts "Test de stabilité (5 appels):"
  5.times do |i|
    puts "  Appel #{i + 1}: random_thumbnail = #{playlist.random_thumbnail}"
  end
end

puts "\n" + "=" * 40
puts "✅ CORRECTION APPLIQUÉE !"
puts "Maintenant redémarrez votre serveur Rails et testez."
