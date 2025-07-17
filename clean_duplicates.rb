#!/usr/bin/env ruby

# Script pour nettoyer les doublons dans les playlists
puts "🧹 Nettoyage des doublons dans les playlists..."

# Charger l'environnement Rails
require_relative 'config/environment'

# Fonction pour nettoyer les doublons d'une playlist
def clean_playlist_duplicates(playlist)
  puts "\n📋 Nettoyage de la playlist: #{playlist.title}"
  puts "🎵 Vidéos avant nettoyage: #{playlist.videos.count}"
  
  # Trouver les doublons par youtube_id
  duplicates = playlist.videos.group(:youtube_id).having('count(*) > 1')
  
  if duplicates.any?
    puts "🔍 Doublons trouvés:"
    duplicates.each do |group|
      youtube_id = group.youtube_id
      videos = playlist.videos.where(youtube_id: youtube_id).order(:id)
      
      # Garder la première vidéo, supprimer les autres
      videos_to_keep = videos.first
      videos_to_delete = videos.offset(1)
      
      puts "  - youtube_id: #{youtube_id}"
      puts "    Gardé: #{videos_to_keep.title} (ID: #{videos_to_keep.id})"
      videos_to_delete.each do |video|
        puts "    Supprimé: #{video.title} (ID: #{video.id})"
        video.destroy
      end
    end
  else
    puts "  ✅ Aucun doublon trouvé"
  end
  
  puts "🎵 Vidéos après nettoyage: #{playlist.reload.videos.count}"
end

# Nettoyer toutes les playlists
Playlist.all.each do |playlist|
  clean_playlist_duplicates(playlist)
end

puts "\n✅ Nettoyage terminé !" 