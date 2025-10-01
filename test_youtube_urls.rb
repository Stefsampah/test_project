#!/usr/bin/env ruby

# Charger l'environnement Rails
require_relative 'config/environment'

puts "=== TEST DE STABILITÉ DES URLs YOUTUBE ==="
playlists_problematiques = ['Afro Vibes Vol. 1', 'Afro Vibes Vol. 3', 'Futurs Hits – Pop & Global Vibes vol.1']

playlists_problematiques.each do |titre|
  playlist = Playlist.find_by(title: titre)
  if playlist
    puts "\n--- #{titre} ---"
    youtube_id = playlist.videos.first&.youtube_id
    
    if youtube_id
      puts "YouTube ID: #{youtube_id}"
      puts "URL maxresdefault: https://img.youtube.com/vi/#{youtube_id}/maxresdefault.jpg?v=20250115"
      puts "URL hqdefault: https://img.youtube.com/vi/#{youtube_id}/hqdefault.jpg?v=20250115"
      puts "URL mqdefault: https://img.youtube.com/vi/#{youtube_id}/mqdefault.jpg?v=20250115"
      puts "URL default: https://img.youtube.com/vi/#{youtube_id}/default.jpg?v=20250115"
    end
  end
end

puts "\n=== SOLUTION ALTERNATIVE ==="
puts "Si le problème persiste, c'est que YouTube change ses thumbnails."
puts "Solution: Utiliser des images locales ou un service de proxy."
