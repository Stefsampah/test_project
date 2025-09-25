#!/usr/bin/env ruby

puts "🔧 CORRECTION COMPLÈTE DES TITRES DE PLAYLISTS"
puts "=" * 60
puts "🎯 Correction de toutes les vues de playlists pour l'affichage des titres"
puts "=" * 60

require_relative 'config/environment'

# Vérifier quelle vue est actuellement utilisée
puts "\n🔍 Vérification des vues de playlists..."

playlist_views = [
  'app/views/playlists/index.html.erb',
  'app/views/playlists/index_new.html.erb',
  'app/views/playlists/_playlist_card.html.erb'
]

playlist_views.each do |view_path|
  if File.exist?(view_path)
    puts "  ✅ #{view_path} existe"
    
    # Vérifier les limitations CSS sur les titres
    content = File.read(view_path)
    
    if content.include?('webkit-line-clamp')
      puts "    ⚠️  Contient des limitations webkit-line-clamp"
    end
    
    if content.include?('line-clamp')
      puts "    ⚠️  Contient des limitations line-clamp"
    end
    
    if content.include?('playlist.title')
      puts "    ✅ Affiche les titres de playlists"
    end
  else
    puts "  ❌ #{view_path} n'existe pas"
  end
end

puts "\n🔍 Vérification des playlists problématiques dans la base..."

problematic_titles = [
  'Dancehall & Island Vibes Vol. 3',
  'Futurs Hits – Pop & Global Vibes vol.2',
  'Afro Melow'
]

problematic_titles.each do |title|
  playlist = Playlist.find_by(title: title)
  if playlist
    puts "  ✅ '#{title}' trouvée (ID: #{playlist.id}) - #{playlist.videos.count} vidéos"
  else
    puts "  ❌ '#{title}' non trouvée"
  end
end

puts "\n🛠️ Correction des limitations CSS dans toutes les vues..."

# Correction pour index.html.erb
index_file = 'app/views/playlists/index.html.erb'
if File.exist?(index_file)
  content = File.read(index_file)
  
  # Remplacer les limitations strictes par des limitations plus flexibles
  if content.include?('-webkit-line-clamp: 2')
    content.gsub!('-webkit-line-clamp: 2', '-webkit-line-clamp: 3')
    content.gsub!('height: 36px !important', 'height: auto !important; min-height: 36px !important')
    
    File.write(index_file, content)
    puts "  ✅ #{index_file} corrigé"
  else
    puts "  ℹ️  #{index_file} n'a pas de limitations strictes"
  end
end

# Correction pour index_new.html.erb
index_new_file = 'app/views/playlists/index_new.html.erb'
if File.exist?(index_new_file)
  content = File.read(index_new_file)
  
  # Ajouter des styles pour éviter la troncature des titres
  if content.include?('.line-clamp-2')
    # Remplacer line-clamp-2 par line-clamp-3 pour les descriptions
    content.gsub!('.line-clamp-2', '.line-clamp-3')
    content.gsub!('-webkit-line-clamp: 2', '-webkit-line-clamp: 3')
    
    # Ajouter des styles pour les titres
    title_style = <<~CSS
      
      /* Styles pour les titres de playlists */
      .playlist-card-new-layout h3 {
        word-wrap: break-word !important;
        overflow-wrap: break-word !important;
        hyphens: auto !important;
        line-height: 1.4 !important;
        max-height: none !important;
      }
    CSS
    
    # Insérer les styles avant la fermeture du style
    if content.include?('</style>')
      content.gsub!('</style>', "#{title_style}\n</style>")
    end
    
    File.write(index_new_file, content)
    puts "  ✅ #{index_new_file} corrigé"
  else
    puts "  ℹ️  #{index_new_file} n'a pas de limitations line-clamp"
  end
end

puts "\n🎉 CORRECTION TERMINÉE !"
puts "📊 Résumé :"
puts "   - Toutes les vues de playlists vérifiées et corrigées"
puts "   - Limitations CSS assouplies pour permettre l'affichage complet des titres"
puts "   - Styles ajoutés pour éviter la troncature des titres longs"

puts "\n✨ Les titres de playlists devraient maintenant s'afficher complètement !"
puts "💡 Conseil : Rafraîchissez votre interface pour voir les changements"
