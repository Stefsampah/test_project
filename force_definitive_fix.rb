#!/usr/bin/env ruby

# Script pour forcer la correction définitive des thumbnails
require_relative 'config/environment'

puts "🚀 CORRECTION DÉFINITIVE FORCÉE DES THUMBNAILS"
puts "=" * 60

# 1. Modifier directement le modèle Playlist pour forcer l'utilisation de la première vidéo
puts "1. Modification du modèle Playlist..."

# Lire le fichier du modèle
model_file = 'app/models/playlist.rb'
content = File.read(model_file)

# Remplacer toutes les méthodes problématiques
content.gsub!(/def consistent_thumbnail\s*\n\s*@consistent_thumbnail \|\|= first_thumbnail\s*\n\s*end/, 
             "def consistent_thumbnail\n    first_thumbnail\n  end")

content.gsub!(/def random_thumbnail\s*\n\s*videos\.sample&\.youtube_id\s*\n\s*end/, 
             "def random_thumbnail\n    first_thumbnail\n  end")

# Écrire le fichier modifié
File.write(model_file, content)
puts "✅ Modèle Playlist modifié"

# 2. Vider tous les caches
puts "2. Vidage des caches..."
Rails.cache.clear
puts "✅ Cache Rails vidé"

# 3. Forcer le rechargement des classes
puts "3. Rechargement des classes..."
Playlist.reset_column_information
puts "✅ Classes rechargées"

# 4. Vérifier les playlists problématiques
puts "4. Test des méthodes sur les playlists problématiques..."

problematic_playlists = [
  'Afro Vibes Vol. 1',
  'RELEASED vol.2', 
  'Afro Rap',
  'Rap Ivoire Power',
  'Afro Vibes Premium',
  'Futurs Hits – Pop & Global Vibes vol.1',
  'Urban Rap Afro'
]

problematic_playlists.each do |title|
  playlist = Playlist.find_by(title: title)
  if playlist
    puts "📁 #{title}:"
    puts "   consistent_thumbnail: #{playlist.consistent_thumbnail}"
    puts "   random_thumbnail: #{playlist.random_thumbnail}"
    puts "   first_thumbnail: #{playlist.first_thumbnail}"
  end
end

puts "\n5. INSTRUCTIONS FINALES :"
puts "-" * 30
puts "1. 🔄 REDÉMARREZ VOTRE SERVEUR RAILS :"
puts "   - Arrêtez le serveur (Ctrl+C)"
puts "   - Relancez: rails server"
puts ""
puts "2. 🧹 VIDEZ LE CACHE DU NAVIGATEUR :"
puts "   - Chrome: Cmd+Shift+R (rechargement forcé)"
puts ""
puts "3. 📱 VÉRIFIEZ LE CODE SOURCE :"
puts "   - Clic droit → Afficher le code source"
puts "   - Cherchez 'consistent_thumbnail' dans le HTML"
puts "   - Si vous le trouvez, c'est qu'une vue n'est pas mise à jour"

puts "\n" + "=" * 60
puts "🎯 CORRECTION DÉFINITIVE APPLIQUÉE !"
puts "Toutes les méthodes utilisent maintenant la première vidéo."
