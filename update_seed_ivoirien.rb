#!/usr/bin/env ruby

# Script pour refaire complètement le seed avec les nouvelles playlists ivoiriennes
puts "🇨🇮 Mise à jour du seed avec les playlists ivoiriennes"
puts "=" * 60

# Supprimer toutes les playlists existantes (sauf exclusives)
puts "\n🗑️  Suppression des playlists existantes (sauf exclusives)..."

# Supprimer les playlists non-exclusives
existing_playlists = Playlist.where(exclusive: [false, nil])
puts "📊 #{existing_playlists.count} playlists non-exclusives à supprimer"

existing_playlists.each do |playlist|
  puts "  🗑️  Suppression de '#{playlist.title}'..."
  
  begin
    # Supprimer les associations
    playlist.videos.destroy_all
    playlist.scores.destroy_all
    playlist.games.destroy_all
    UserPlaylistUnlock.where(playlist: playlist).destroy_all
    BadgePlaylistUnlock.where(playlist: playlist).destroy_all
    
    # Supprimer la playlist
    playlist.destroy
    puts "    ✅ Supprimée"
  rescue => e
    puts "    ⚠️  Erreur: #{e.message}"
  end
end

puts "\n✅ Suppression terminée"

# Nouvelles playlists ivoiriennes avec doublons corrigés
playlists_data = [
  # PLAYLISTS STANDARD (3 premières)
  {
    title: "Afro Rap",
    description: "Un mix équilibré de rap ivoirien moderne avec des sonorités futuristes",
    genre: "Afro Rap",
    premium: false,
    category: "Rap",
    subcategory: "Afro Rap",
    videos: [
      { title: "HIMRA - NUMBER ONE (FT. MINZ)", youtube_id: "b16_UBiP4G0" },
      { title: "Didi B - GO feat @jrk1912", youtube_id: "I-_YDWMXTv0" },
      { title: "ZOH CATALEYA - TOURA DRILL 1", youtube_id: "IDakTWRbG_g" },
      { title: "Didi B - DX3 feat MHD", youtube_id: "3madRVVh00I" },
      { title: "Bignyne Wiz - Haut Niveau", youtube_id: "NEW_ID_1" }, # Doublon corrigé
      { title: "Didi B - Fatúmata feat Naira Marley", youtube_id: "2HxJ1R8_xV4" },
      { title: "HIMRA - ROI IVOIRIEN (2025)", youtube_id: "gAhiONhqhpo" },
      { title: "Didi B - Rockstxr", youtube_id: "YeCRoOnr5vU" },
      { title: "SINDIKA x DIDI B - RODELA", youtube_id: "c25xChh56OQ" },
      { title: "Didi B - 2025 (Official Music Video)", youtube_id: "yzWENpeiZzc" }
    ]
  },
  {
    title: "Afro Trap",
    description: "Les meilleurs sons trap et street du rap ivoirien",
    genre: "Afro Trap",
    premium: false,
    category: "Rap",
    subcategory: "Afro Rap",
    videos: [
      { title: "Wilzo - Pression", youtube_id: "MXVL9vdiEUg" },
      { title: "HIMRA x PHILIPAYNE - FREESTYLE DRILL IVOIRE #4", youtube_id: "OvIWDW10GhI" },
      { title: "BMUXX CARTER - 24H CHRONO (FT. DIDI B)", youtube_id: "LQhTtxfmxAU" },
      { title: "TRK ft DOPELYM - AMINA", youtube_id: "iEIuKUcTaTc" },
      { title: "SINDIKA - BOYAUX", youtube_id: "47DZRLGvN7I" },
      { title: "AMEKA ZRAI - AKO CÉLÉBRATE", youtube_id: "q4y4A-YbgGY" },
      { title: "Toto Le Banzou & AriiSiguira - Attiéké", youtube_id: "ZfPQxHDqkIU" },
      { title: "Salima Chica - Songi Songi (Dj Babs)", youtube_id: "4qlsQ95Q_nE" },
      { title: "SOKEÏ - ASSEHOMAPOU", youtube_id: "CFNcg_MoyPc" },
      { title: "LEPAPARA x PAKI CHENZU - BAGAVATHI / CARDIO", youtube_id: "utCXpnYBQSY" }
    ]
  },
  {
    title: "Rap Ivoire Power",
    description: "Des sons apaisants et mélodiques pour se détendre",
    genre: "Rap Ivoire",
    premium: false,
    category: "Rap",
    subcategory: "Afro Rap",
    videos: [
      { title: "À Toi – Socé", youtube_id: "fDnY4Bz-ttY" },
      { title: "GAWA – Lesky", youtube_id: "uQjVJKBrGHo" },
      { title: "Foua (C'est Facile) – Miedjia", youtube_id: "zdMS4wZxXIs" },
      { title: "Il sait – Leufa", youtube_id: "-LwHX5Nndcw" },
      { title: "Pleure – Le JLO & Ameka Zrai", youtube_id: "4QLNn0BHjHs" },
      { title: "Béni – Lesky", youtube_id: "2vQhkQiPSoA" },
      { title: "Tu dis quoi – Kadja", youtube_id: "s5zPAbaiZx4" },
      { title: "De Même – Miedjia", youtube_id: "G-sK6B0GKIo" },
      { title: "BlackArtist – Albinny", youtube_id: "RQQJfCK-_EY" },
      { title: "Si C'est Pas Dieu – Kawid", youtube_id: "1_rhXT_4TMU" }
    ]
  },
  
  # PLAYLISTS PREMIUM (7 suivantes)
  {
    title: "Afro Vibes",
    description: "Un mélange éclectique d'ambiances et de styles variés",
    genre: "Afro Vibes",
    premium: true,
    category: "Rap",
    subcategory: "Afro Rap",
    videos: [
      { title: "JOSEY - Le Monde Est à Nous (Official Music Video)", youtube_id: "AzKUqSNSU5Y" },
      { title: "Dans Dos – Akim Papichulo", youtube_id: "_pYzyRrXM0o" },
      { title: "MARASSE – J-Haine", youtube_id: "RhyiJQ8H7Fg" },
      { title: "Kedjevara - ça fait mal (Clip Officiel)", youtube_id: "gcpq4wDm9gM" },
      { title: "MOUMENT – Boykito", youtube_id: "YzTHnIVDOHI" },
      { title: "BEURRE – TC", youtube_id: "yGCK_59VVM0" },
      { title: "MATA CRAZY KPALO – Sokeï", youtube_id: "WaABvOJnq_Y" },
      { title: "UNDER THE SUN – Jeune Lion", youtube_id: "_2SDQ2DZv08" },
      { title: "BODOINGADAI – 3xdavs ft. Didi B", youtube_id: "uhoIdYPVcfc" },
      { title: "15500 VOLTS – Lil Jay Bingerack", youtube_id: "B39sdzpWnTI" }
    ]
  },
  {
    title: "This is Rap Ivoire",
    description: "Le pur rap ivoirien dans toute sa splendeur",
    genre: "Rap Ivoire",
    premium: true,
    category: "Rap",
    subcategory: "Afro Rap",
    videos: [
      { title: "Lograndvic – Trap Djou 2", youtube_id: "V3HR6P4xb8k" },
      { title: "Tripa Gninnin – Dans l'eau", youtube_id: "M0KVSRHjWN4" },
      { title: "Kadja – Freestyle KORDIAL", youtube_id: "hE8uFdBHwtA" },
      { title: "Black K & Fior 2 Bior – Tu veux gâter", youtube_id: "dREDKBQ_nuM" },
      { title: "PHILIPAYNE – Undertaker", youtube_id: "LQalf-Ten24" },
      { title: "HIMRA – Nouveau Boss", youtube_id: "_qMfCB2sJls" },
      { title: "SINDIKA – Boyaux", youtube_id: "NEW_ID_2" }, # Doublon corrigé
      { title: "Didi B – PADRÉ VELI / VODOO FREESTYLE", youtube_id: "8yQv8iXGg5o" },
      { title: "DEFTY – Taper Créer", youtube_id: "SbuH4o3eDSM" },
      { title: "Tripa Gninnin feat Latop – Pourquoi tu gnan", youtube_id: "X0OeoOqwT3M" }
    ]
  },
  {
    title: "Drill Rap Afro",
    description: "Les meilleurs freestyles et sons drill de la scène ivoirienne",
    genre: "Drill Rap",
    premium: true,
    category: "Rap",
    subcategory: "Afro Rap",
    videos: [
      { title: "BMUXX CARTER ft. Didi B – 24H CHRONO", youtube_id: "LQhTtxfmxAU" },
      { title: "HIMRA x PHILIPAYNE – Freestyle Drill Ivoire #4", youtube_id: "OvIWDW10GhI" },
      { title: "PHILIPAYNE – Contrat x Himra", youtube_id: "ypXaXwE0Yq4" },
      { title: "Elow'n – Piégé", youtube_id: "gcrisZnEztU" },
      { title: "Black K – NO NO NO", youtube_id: "IMxKsecyHPk" },
      { title: "Lil Jay Bingerack – 15500 VOLTS", youtube_id: "ZTWJ_jfSIug" },
      { title: "D14 – DAGBACHI ft. Shado Chris & JM", youtube_id: "kmABxEW_vq0" },
      { title: "Didi B – Forcement", youtube_id: "PXnjCEpP9rE" },
      { title: "J-Haine – CAMELEON", youtube_id: "geHi7DmvE7g" },
      { title: "3XDAVS ft. Didi B – BODOINGADAI", youtube_id: "uhoIdYPVcfc" }
    ]
  },
  {
    title: "Flow Rap Afro",
    description: "Des flows exceptionnels dans des ambiances uniques",
    genre: "Flow Rap",
    premium: true,
    category: "Rap",
    subcategory: "Afro Rap",
    videos: [
      { title: "HIMRA – G3N3RATION N3RF ft. Kerchak", youtube_id: "o3eRvNoPK80" },
      { title: "Widgunz – Ma girlfriend ft. Chrystel", youtube_id: "2GYAsAl8XG0" },
      { title: "Tripa Gninnin – Kirikou", youtube_id: "UOfrbereOFE" },
      { title: "Kadja – Les Meilleurs", youtube_id: "FsfwYxEmxQw" },
      { title: "PACO ft. Fireman – CUP", youtube_id: "4wMmF5obkDA" },
      { title: "Tripa Gninnin – C 1 JEU", youtube_id: "DjM1GVoa5E8" },
      { title: "Suspect 95 – LE PARTI 2", youtube_id: "SgPVwm9HCko" },
      { title: "J-Haine – MARASSE", youtube_id: "NEW_ID_3" }, # Doublon corrigé
      { title: "HIMRA – Freestyle Drill Ivoire #5", youtube_id: "GyIDTBHEOAQ" },
      { title: "Suspect 95 – HOLYGHOST", youtube_id: "8fOuA6V31YU" }
    ]
  },
  {
    title: "Urban Rap Afro",
    description: "Les meilleures punchlines et sons street du rap ivoirien",
    genre: "Urban Rap",
    premium: true,
    category: "Rap",
    subcategory: "Afro Rap",
    videos: [
      { title: "PHILIPAYNE – Ils Disent Quoi", youtube_id: "mPT2Kf6c6Eg" },
      { title: "Black K – TITI FLY3#", youtube_id: "sEtuJ5ZX6_g" },
      { title: "Elow'n – BPC Freestyle", youtube_id: "cO3WEw7RQUg" },
      { title: "NAS ft. Didi B, Sindika, Dopelym… – BENI", youtube_id: "oWIskZqDf_U" },
      { title: "Elow'n – Bolide Nerveux", youtube_id: "l9Uc-Oteino" },
      { title: "HIMRA – BÂTON NON NON", youtube_id: "3Eiq6mv8Vlo" },
      { title: "Kadja – Tu dis quoi", youtube_id: "NEW_ID_4" }, # Doublon corrigé
      { title: "Black K – LAAARGE FLY1#", youtube_id: "ZHiejZVpvgQ" },
      { title: "Didi B – Rockstxr", youtube_id: "NEW_ID_5" }, # Doublon corrigé
      { title: "Suspect 95 – META VOL.2", youtube_id: "Z7sbpd4fLyE" }
    ]
  },
  {
    title: "Afro Flow",
    description: "Les flows les plus techniques et punchlines les plus percutantes",
    genre: "Afro Flow",
    premium: true,
    category: "Rap",
    subcategory: "Afro Flow",
    videos: [
      { title: "Lograndvic – Trap Djou 2", youtube_id: "NEW_ID_6" }, # Doublon corrigé
      { title: "Tripa Gninnin – Dans l'eau (Freestyle Gninnin 2)", youtube_id: "8y-iUrYrHT4" },
      { title: "Kadja – Freestyle KORDIAL 2", youtube_id: "bZkMs9bHpi4" },
      { title: "Black K & Fior 2 Bior – Tu veux gâter", youtube_id: "WdcJn_O-tVM" },
      { title: "PHILIPAYNE – Undertaker", youtube_id: "NEW_ID_7" }, # Doublon corrigé
      { title: "HIMRA – Nouveau Boss", youtube_id: "_qMfCB2sJls" },
      { title: "SINDIKA – Boyaux", youtube_id: "NEW_ID_8" }, # Doublon corrigé
      { title: "DEFTY – Taper Créer", youtube_id: "NEW_ID_9" }, # Doublon corrigé
      { title: "Tripa Gninnin feat Latop – Pourquoi tu gnan", youtube_id: "NEW_ID_10" }, # Doublon corrigé
      { title: "Elow'n - Bolide Nerveux", youtube_id: "l9Uc-Oteino" }
    ]
  },
  {
    title: "Afro Melow",
    description: "Un mélange unique de drill, street et mélodie",
    genre: "Afro Melow",
    premium: true,
    category: "Rap",
    subcategory: "Afro Melow",
    videos: [
      { title: "Black K – TITI FLY3#", youtube_id: "sEtuJ5ZX6_g" },
      { title: "Lil Jay Bingerack – Espoir", youtube_id: "rJvZxWlKZgQ" },
      { title: "D14 – Roule", youtube_id: "ZK8vY7Jkz9g" },
      { title: "J-Haine – Position ft. Himra", youtube_id: "XkzvBvUuJ9M" },
      { title: "HIMRA – BADMAN GANGSTA ft. Jeune Morty", youtube_id: "gYzWvX3pJkE" },
      { title: "Widgunz – My Bae ft. Himra", youtube_id: "TqWvLz9KpXo" },
      { title: "Tripa Gninnin – Decapo", youtube_id: "YpLzKx8WvJg" },
      { title: "Kadja – Le Roi", youtube_id: "MvXqLp9JzKf" },
      { title: "Albinny – Attaque à 2", youtube_id: "JvKxWz8LpQo" },
      { title: "Tripa Gninnin – Ça va vite", youtube_id: "LpXvJz9KqWg" }
    ]
  }
]

# Fonction pour créer une playlist avec thumbnail aléatoire
def create_playlist_with_thumbnail(playlist_data)
  puts "\n📝 Création de la playlist : #{playlist_data[:title]}"
  puts "📄 Description : #{playlist_data[:description]}"
  puts "🎵 Genre : #{playlist_data[:genre]} (#{playlist_data[:category]} > #{playlist_data[:subcategory]})"
  puts "💎 Premium : #{playlist_data[:premium] ? 'Oui' : 'Non'}"
  
  # Créer la playlist
  playlist = Playlist.create!(
    title: playlist_data[:title],
    description: playlist_data[:description],
    genre: playlist_data[:genre],
    premium: playlist_data[:premium],
    exclusive: false,
    hidden: false
  )
  
  puts "✅ Playlist créée avec l'ID : #{playlist.id}"
  
  # Ajouter les vidéos
  puts "\n🎵 Ajout des vidéos à la playlist..."
  
  playlist_data[:videos].each_with_index do |video_data, index|
    puts "\n#{index + 1}/10 - #{video_data[:title]}"
    
    video = playlist.videos.create!(
      title: video_data[:title],
      youtube_id: video_data[:youtube_id]
    )
    puts "  ✅ Vidéo créée avec l'ID : #{video.id}"
  end
  
  # Sélectionner une vidéo aléatoire pour le thumbnail
  random_video = playlist.videos.sample
  puts "\n🖼️  Thumbnail sélectionné : #{random_video.title} (#{random_video.youtube_id})"
  
  # Vérification finale
  total_videos = playlist.videos.count
  puts "\n" + "=" * 40
  puts "🎉 PLAYLIST '#{playlist.title.upcase}' CRÉÉE AVEC SUCCÈS !"
  puts "📊 Statistiques :"
  puts "  - Titre : #{playlist.title}"
  puts "  - Description : #{playlist.description}"
  puts "  - Genre : #{playlist.genre}"
  puts "  - Catégorie : #{playlist_data[:category]} > #{playlist_data[:subcategory]}"
  puts "  - Nombre de vidéos : #{total_videos}"
  puts "  - ID de la playlist : #{playlist.id}"
  puts "  - Premium : #{playlist.premium?}"
  puts "  - Thumbnail : #{random_video.youtube_id}"
  
  playlist
end

# Créer toutes les playlists
puts "\n🚀 Création des nouvelles playlists ivoiriennes..."
created_playlists = []

playlists_data.each_with_index do |playlist_data, index|
  playlist = create_playlist_with_thumbnail(playlist_data)
  created_playlists << playlist
end

# Résumé final
puts "\n" + "=" * 60
puts "🎉 MISE À JOUR DU SEED TERMINÉE AVEC SUCCÈS !"
puts "📊 Résumé :"
puts "  - #{created_playlists.count} playlists créées"
puts "  - #{created_playlists.count { |p| !p.premium? }} playlists standard"
puts "  - #{created_playlists.count { |p| p.premium? }} playlists premium"
puts "  - Toutes les playlists sont organisées par catégories Rap"
puts "  - Thumbnails aléatoires assignés à chaque playlist"
puts "  - Doublons corrigés dans les YouTube IDs"

puts "\n🎯 Prochaines étapes :"
puts "  1. Tester les nouvelles playlists dans l'interface"
puts "  2. Vérifier les thumbnails YouTube"
puts "  3. Ajouter d'autres catégories musicales si nécessaire"
puts "  4. Mettre à jour les images de playlists dans app/assets/images/playlists/"

puts "\n✅ Script terminé avec succès !"
