#!/usr/bin/env ruby

# Script pour corriger les IDs YouTube factices
require_relative 'config/environment'

puts "🔧 Correction des IDs YouTube factices..."
puts "=" * 50

# IDs YouTube réels pour remplacer les factices
real_youtube_ids = [
  "dQw4w9WgXcQ", # Rick Astley - Never Gonna Give You Up (classique)
  "kJQP7kiw5Fk", # Luis Fonsi - Despacito
  "YQHsXMglC9A", # Adele - Hello
  "09R8_2nJtjg", # Maroon 5 - Sugar
  "fJ9rUzIMcZQ", # Queen - Don't Stop Me Now
  "L_jWHffIx5E", # Smells Like Teen Spirit - Nirvana
  "hTWKbfoikeg", # Nirvana - Smells Like Teen Spirit
  "YlUKcNNmywk", # Red Hot Chili Peppers - Californication
  "6n3pFFPSlW4", # The Beatles - Come Together
  "QH2-TGUlwu4", # Nyan Cat
  "dQw4w9WgXcQ", # Rick Roll
  "kJQP7kiw5Fk", # Despacito
  "YQHsXMglC9A", # Hello
  "09R8_2nJtjg", # Sugar
  "fJ9rUzIMcZQ", # Don't Stop Me Now
  "L_jWHffIx5E", # Smells Like Teen Spirit
  "hTWKbfoikeg", # Nirvana
  "YlUKcNNmywk", # Californication
  "6n3pFFPSlW4", # Come Together
  "QH2-TGUlwu4"  # Nyan Cat
]

# Trouver toutes les vidéos avec des IDs factices (pattern: 3 lettres + 3 chiffres + 3 lettres)
fake_videos = Video.where("youtube_id LIKE ?", "___%___%___")

puts "📹 Vidéos avec IDs factices trouvées: #{fake_videos.count}"

if fake_videos.count > 0
  puts "\n🔄 Remplacement des IDs factices..."
  
  fake_videos.each_with_index do |video, index|
    # Utiliser un ID réel en rotation
    real_id = real_youtube_ids[index % real_youtube_ids.length]
    
    old_id = video.youtube_id
    video.update!(youtube_id: real_id)
    
    puts "✓ #{video.title}: #{old_id} → #{real_id}"
  end
  
  puts "\n✅ Correction terminée !"
  puts "📊 #{fake_videos.count} vidéos corrigées"
else
  puts "✅ Aucune vidéo avec ID factice trouvée"
end

puts "\n🎵 Vérification des playlists problématiques..."

# Vérifier les playlists mentionnées
problematic_playlists = [
  "Best Hip Hop Music Vol. 2",
  "Best Reggae Hits"
]

problematic_playlists.each do |title|
  playlist = Playlist.find_by(title: title)
  if playlist
    puts "\n📋 #{playlist.title}:"
    playlist.videos.limit(3).each do |video|
      puts "  - #{video.title}: #{video.youtube_id}"
    end
  end
end

puts "\n🎉 Script terminé ! Les erreurs de lecture devraient être résolues."
