namespace :fix_playlist_display do
  desc "Corriger les problèmes d'affichage des playlists"
  task all: :environment do
    puts "=== CORRECTION DES PROBLÈMES D'AFFICHAGE DES PLAYLISTS ==="
    
    # 1. Corriger les playlists avec hidden nil
    puts "\n1. Correction des playlists avec hidden nil..."
    hidden_nil_playlists = Playlist.where(hidden: nil)
    puts "Playlists avec hidden nil: #{hidden_nil_playlists.count}"
    
    hidden_nil_playlists.each do |playlist|
      # Les playlists premium doivent être cachées par défaut
      # Les playlists non-premium doivent être visibles
      new_hidden_value = playlist.premium? ? true : false
      
      playlist.update!(hidden: new_hidden_value)
      puts "  ✅ ID #{playlist.id}: '#{playlist.title}' - Hidden: #{new_hidden_value}"
    end
    
    # 2. Corriger les playlists avec points_required nil
    puts "\n2. Correction des playlists avec points_required nil..."
    points_nil_playlists = Playlist.where(points_required: nil)
    puts "Playlists avec points_required nil: #{points_nil_playlists.count}"
    
    points_nil_playlists.each do |playlist|
      # Les playlists premium doivent avoir 500 points par défaut
      # Les playlists non-premium doivent avoir 0 points
      new_points_value = playlist.premium? ? 500 : 0
      
      playlist.update!(points_required: new_points_value)
      puts "  ✅ ID #{playlist.id}: '#{playlist.title}' - Points: #{new_points_value}"
    end
    
    # 3. Corriger spécifiquement la playlist Exclusive
    puts "\n3. Correction de la playlist Exclusive..."
    exclusive_playlist = Playlist.find_by(title: "Exclusive Playlist")
    if exclusive_playlist
      exclusive_playlist.update!(
        hidden: true,
        points_required: 9999  # Prix inaccessible pour forcer l'accès via récompenses
      )
      puts "  ✅ Playlist Exclusive corrigée - Hidden: true, Points: 9999"
    else
      puts "  ❌ Playlist Exclusive non trouvée"
    end
    
    # 4. Vérifier les doublons et suggérer des corrections
    puts "\n4. Vérification des doublons..."
    
    # Vérifier les doublons Futurs Hits
    futurs_hits = Playlist.where("title LIKE ?", "%Futurs Hits%")
    if futurs_hits.count > 1
      puts "  ⚠️  Doublons Futurs Hits détectés:"
      futurs_hits.each do |playlist|
        puts "    - ID #{playlist.id}: '#{playlist.title}'"
      end
      puts "  💡 Suggestion: Renommer ou supprimer les doublons"
    end
    
    # Vérifier les doublons Dancehall
    dancehall = Playlist.where("title LIKE ?", "%Dancehall%")
    if dancehall.count > 1
      puts "  ⚠️  Doublons Dancehall détectés:"
      dancehall.each do |playlist|
        puts "    - ID #{playlist.id}: '#{playlist.title}'"
      end
      puts "  💡 Suggestion: Renommer ou supprimer les doublons"
    end
    
    # 5. Vérification finale
    puts "\n5. Vérification finale..."
    
    remaining_hidden_nil = Playlist.where(hidden: nil).count
    remaining_points_nil = Playlist.where(points_required: nil).count
    
    puts "Playlists avec hidden nil restantes: #{remaining_hidden_nil}"
    puts "Playlists avec points_required nil restantes: #{remaining_points_nil}"
    
    if remaining_hidden_nil == 0 && remaining_points_nil == 0
      puts "\n✅ Toutes les corrections ont été appliquées avec succès !"
    else
      puts "\n❌ Il reste des problèmes à corriger"
    end
    
    puts "\n=== CORRECTION TERMINÉE ==="
  end
  
  desc "Vérifier l'état des playlists après correction"
  task verify: :environment do
    puts "=== VÉRIFICATION DE L'ÉTAT DES PLAYLISTS ==="
    
    # Vérifier les playlists problématiques
    problematic_playlists = Playlist.where(hidden: nil).or(Playlist.where(points_required: nil))
    
    if problematic_playlists.any?
      puts "❌ Playlists avec problèmes restantes: #{problematic_playlists.count}"
      problematic_playlists.each do |playlist|
        puts "  - ID #{playlist.id}: '#{playlist.title}' - Hidden: #{playlist.hidden} - Points: #{playlist.points_required}"
      end
    else
      puts "✅ Aucune playlist avec problèmes détectée"
    end
    
    # Vérifier les playlists premium
    premium_playlists = Playlist.where(premium: true)
    puts "\nPlaylists premium: #{premium_playlists.count}"
    
    premium_playlists.each do |playlist|
      status = (playlist.hidden? && playlist.points_required == 500) ? "✅" : "❌"
      puts "  #{status} ID #{playlist.id}: '#{playlist.title}' - Hidden: #{playlist.hidden?} - Points: #{playlist.points_required}"
    end
    
    puts "\n=== VÉRIFICATION TERMINÉE ==="
  end
end
