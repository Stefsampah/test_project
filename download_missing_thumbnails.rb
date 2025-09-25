#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'fileutils'

puts "=== TÉLÉCHARGEMENT DES THUMBNAILS MANQUANTS ==="

# Créer le dossier pour stocker les images
images_dir = File.join(Dir.pwd, 'public', 'playlist_thumbnails')
FileUtils.mkdir_p(images_dir)

# IDs des playlists manquantes avec leurs YouTube IDs
playlists_manquantes = {
  32 => 'XILS3CclI1k',  # RELEASED vol.2
  25 => 'V3HR6P4xb8k',  # Afro Flow  
  29 => 'uhoIdYPVcfc'   # Drill Rap Afro
}

playlists_manquantes.each do |playlist_id, youtube_id|
  puts "\n--- Playlist ID: #{playlist_id} ---"
  puts "YouTube ID: #{youtube_id}"
  
  # Essayer différentes qualités
  qualities = ['maxresdefault', 'hqdefault', 'mqdefault', 'default']
  
  qualities.each do |quality|
    url = "https://img.youtube.com/vi/#{youtube_id}/#{quality}.jpg"
    filename = "#{playlist_id}_#{quality}.jpg"
    filepath = File.join(images_dir, filename)
    
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

puts "\n=== TERMINÉ ==="
puts "Les thumbnails sont maintenant stockés dans: #{images_dir}"
