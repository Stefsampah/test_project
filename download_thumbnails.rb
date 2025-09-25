#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'fileutils'

puts "=== TÉLÉCHARGEMENT DES THUMBNAILS YOUTUBE ==="

# Créer le dossier pour stocker les images
images_dir = Rails.root.join('public', 'playlist_thumbnails')
FileUtils.mkdir_p(images_dir)

playlists_problematiques = [
  'Afro Vibes Vol. 1', 'Afro Vibes Vol. 3', 'Futurs Hits – Pop & Global Vibes vol.1',
  'Afro Melow', 'Urban Rap Afro', 'RELEASED vol.2', 'Afro Rap', 
  'Rap Ivoire Power', 'Afro Vibes Premium'
]

playlists_problematiques.each do |titre|
  playlist = Playlist.find_by(title: titre)
  if playlist
    youtube_id = playlist.videos.first&.youtube_id
    if youtube_id
      puts "\n--- #{titre} ---"
      puts "YouTube ID: #{youtube_id}"
      
      # Essayer différentes qualités
      qualities = ['maxresdefault', 'hqdefault', 'mqdefault', 'default']
      
      qualities.each do |quality|
        url = "https://img.youtube.com/vi/#{youtube_id}/#{quality}.jpg"
        filename = "#{playlist.id}_#{quality}.jpg"
        filepath = images_dir.join(filename)
        
        begin
          uri = URI(url)
          response = Net::HTTP.get_response(uri)
          
          if response.code == '200'
            File.open(filepath, 'wb') do |file|
              file.write(response.body)
            end
            puts "✅ Téléchargé: #{quality} (#{response.body.length} bytes)"
            break # Arrêter au premier succès
          else
            puts "❌ Échec: #{quality} (code: #{response.code})"
          end
        rescue => e
          puts "❌ Erreur: #{quality} - #{e.message}"
        end
      end
    end
  end
end

puts "\n=== TERMINÉ ==="
puts "Les thumbnails sont maintenant stockés dans: #{images_dir}"
puts "Vous pouvez maintenant utiliser des URLs locales au lieu de YouTube."
