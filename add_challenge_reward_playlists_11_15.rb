#!/usr/bin/env ruby

# Script pour ajouter les playlists challenge_reward_videos_11 à 15
puts "🎵 Création des playlists challenge_reward_videos_11 à 15"
puts "=" * 60

# Supprimer la playlist "Exclusive Playlist" qui crée des doublons
puts "\n🗑️  Suppression de la playlist 'Exclusive Playlist' pour éviter les doublons..."
exclusive_playlist = Playlist.find_by(title: 'Exclusive Playlist')
if exclusive_playlist
  puts "⚠️  Suppression de la playlist 'Exclusive Playlist' (ID: #{exclusive_playlist.id})..."
  
  # Supprimer d'abord les associations
  begin
    # Supprimer les vidéos associées
    exclusive_playlist.videos.destroy_all
    puts "  🗑️  Vidéos supprimées"
    
    # Supprimer les associations avec les badges
    BadgePlaylistUnlock.where(playlist: exclusive_playlist).destroy_all
    puts "  🗑️  Associations badges supprimées"
    
    # Supprimer les associations avec les utilisateurs
    UserPlaylistUnlock.where(playlist: exclusive_playlist).destroy_all
    puts "  🗑️  Associations utilisateurs supprimées"
    
    # Maintenant supprimer la playlist
    exclusive_playlist.destroy
    puts "✅ Playlist 'Exclusive Playlist' supprimée avec succès."
  rescue => e
    puts "⚠️  Erreur lors de la suppression : #{e.message}"
    puts "  ℹ️  Continuation du script..."
  end
else
  puts "ℹ️  La playlist 'Exclusive Playlist' n'existe pas déjà."
end

# Mettre à jour la playlist Challenge Reward Playlist 2 avec les nouvelles versions
puts "\n🔄 Mise à jour de la playlist 'Challenge Reward Playlist 2' avec les nouvelles versions..."
challenge_reward_playlist_2 = Playlist.find_by(title: 'Challenge Reward Playlist 2')
if challenge_reward_playlist_2
  puts "📝 Mise à jour de la playlist : Challenge Reward Playlist 2"
  
  # Nouvelles données pour la playlist 2
  songs_2_updated = [
    {
      title: "ÇA GLOW",
      artist: "HIMRA",
      youtube_id: "9_esOJNo7tA",
      description: "Version originale exclusive sur le DVM Show"
    },
    {
      title: "Lose Yourself",
      artist: "Eminem",
      youtube_id: "KB9dso-h_Es",
      description: "Remix collaboratif avec légendes du rap (2Pac, Biggie, etc.)"
    },
    {
      title: "Ms. Jackson",
      artist: "OutKast",
      youtube_id: "f9mWmTF7Vus",
      description: "Version longue et exclusive"
    },
    {
      title: "Type Beat (flow)",
      artist: "dannyebtracks",
      youtube_id: "AmgA3KiUcU0",
      description: "FREESTYLE TYPE BEAT - I'AM THE FLOW - instrumental trap intense"
    },
    {
      title: "EARFQUAKE",
      artist: "Tyler, The Creator",
      youtube_id: "IJilkMPqvs0",
      description: "Live at the GRAMMYs"
    },
    {
      title: "No Role Modelz",
      artist: "J. Cole",
      youtube_id: "TT7qd0yCVxU",
      description: "Version originale"
    },
    {
      title: "Last Last",
      artist: "Burna Boy",
      youtube_id: "goGhspFE-To",
      description: "Acoustic Cover - interprétation guitare émotive"
    },
    {
      title: "No One",
      artist: "Alicia Keys",
      youtube_id: "WHNHiaEnsgY",
      description: "Piano & I: AOL Sessions - version piano intime"
    },
    {
      title: "HUMBLE.",
      artist: "Kendrick Lamar",
      youtube_id: "gyOcv436f14",
      description: "Extended Version feat. Mad Squablz - version enrichie avec remix"
    },
    {
      title: "Royals",
      artist: "Lorde",
      youtube_id: "vZdCk7PoPeM",
      description: "Rick Ross Remix ft Lorde"
    }
  ]
  
  # Supprimer les anciennes vidéos
  challenge_reward_playlist_2.videos.destroy_all
  puts "🗑️  Anciennes vidéos supprimées"
  
  # Ajouter les nouvelles vidéos
  songs_2_updated.each_with_index do |song, index|
    video = challenge_reward_playlist_2.videos.create!(
      title: "#{song[:title]} · #{song[:artist]}",
      youtube_id: song[:youtube_id],
      description: song[:description]
    )
    puts "  ✅ Vidéo #{index + 1}/10 créée : #{song[:title]} par #{song[:artist]}"
  end
  
  puts "✅ Playlist 'Challenge Reward Playlist 2' mise à jour avec succès !"
else
  puts "⚠️  La playlist 'Challenge Reward Playlist 2' n'existe pas encore."
end

# Données des chansons pour challenge_reward_videos_11 (Remixes)
songs_11 = [
  {
    title: "Believe in Love",
    artist: "Teddy Pendergrass",
    youtube_id: "JisweMRQqHM",
    description: "Remix SNP 2k13 Production - version R'n'B revisitée"
  },
  {
    title: "Sooner or Later",
    artist: "Toni Armani",
    youtube_id: "9bZkp7q19f0",
    description: "Version officielle courte"
  },
  {
    title: "Alté Cruise",
    artist: "Odunsi",
    youtube_id: "njBrMQDBmFk",
    description: "Boiler Room Lagos - Live Remix - performance live avec variations exclusives"
  },
  {
    title: "2000 Excursion",
    artist: "Jackboys",
    youtube_id: "K3RCkZcwtiw",
    description: "Enda Echo Breakbeat Remix - version breakbeat sombre et atmosphérique"
  },
  {
    title: "Dumbo",
    artist: "Travis Scott",
    youtube_id: "XI5v_AKeYuw",
    description: "Mike Dean Version (prod. Slxme) - remix avec une touche signature de Mike Dean"
  },
  {
    title: "Adriano",
    artist: "Niska",
    youtube_id: "TLnB1CI3SS4",
    description: "Remix Zouk - version tropicale et dansante"
  },
  {
    title: "No More Parties",
    artist: "Coi Leray",
    youtube_id: "my2ZvqmPaco",
    description: "Remix avec Lil Durk (Clip officiel) - version la plus populaire avec un couplet inédit"
  },
  {
    title: "Nouveau Boss",
    artist: "HIMRA",
    youtube_id: "i7bSdhBMcMg",
    description: "Remix avec Booba - Mashup - version non officielle mais puissante"
  },
  {
    title: "O'Kenneth",
    artist: "Yimaye",
    youtube_id: "wNyf_D_1O3E",
    description: "GHANA Remix avec SRT Gwalla - version collaborative afro-trap"
  },
  {
    title: "WYA",
    artist: "4batz",
    youtube_id: "fECN5GY8eo0",
    description: "WYA REMIX RED - Jay Wheeler, iZaak, De La Rose - remix reggaeton/R&B"
  }
]

# Données des chansons pour challenge_reward_videos_12 (Versions alternatives)
songs_12 = [
  {
    title: "Help Me Find My Drawls",
    artist: "Tonio Armani",
    youtube_id: "Rx9fWKc3M3M",
    description: "Version studio officielle"
  },
  {
    title: "Joy",
    artist: "Snoop Dogg",
    youtube_id: "dP1rvCp8y9s",
    description: "Version immersive avec visuels interactifs"
  },
  {
    title: "ÇA GLOW",
    artist: "HIMRA",
    youtube_id: "aUgCIoZZtzw",
    description: "Version collaborative live avec LaMano"
  },
  {
    title: "My Mind Playin Tricks on Me",
    artist: "Geto Boys",
    youtube_id: "AEkBF5T6fz8",
    description: "DJ \"S\" Rework - remix moderne et sombre"
  },
  {
    title: "Funk Pop Type Beat (feels)",
    artist: "dannyebtracks",
    youtube_id: "mHaI6232p7Q",
    description: "Funk Pop Type Beat \"LOCURA\" - beat exclusif avec groove serré"
  },
  {
    title: "Rapid Fire",
    artist: "Cruel Santino",
    youtube_id: "UYnt869NR80", # Garder l'ID existant car la version MAFF n'est pas sur YouTube
    description: "MAFF Archive Version - version exclusive MAFF"
  },
  {
    title: "White Noise",
    artist: "Joyner Lucas",
    youtube_id: "y-YAnyGzJY8", # Garder l'ID existant car la version TikTok n'est pas sur YouTube
    description: "TikTok ADHD Anthem - version virale dédiée à l'ADHD"
  },
  {
    title: "Fuego",
    artist: "Manu Crooks & Anfa Rose",
    youtube_id: "oFi-t0EdmOs",
    description: "Version avec paroles et ambiance chill"
  },
  {
    title: "Mary Jane (All Night Long)",
    artist: "Mary J. Blige",
    youtube_id: "M9xy3gt4ivs",
    description: "Remix ft. LL COOL J - version remixée officielle"
  },
  {
    title: "Cowgirl Trailride (feat. Tonio Armani)",
    artist: "S Dott",
    youtube_id: "JSPxTP6V1WE",
    description: "Jammin Jay Lovers Remix - remix doux et dansant"
  }
]

# Données des chansons pour challenge_reward_videos_13 (Versions live)
songs_13 = [
  {
    title: "Believe in Love",
    artist: "Teddy Pendergrass",
    youtube_id: "JisweMRQqHM",
    description: "Version live remixée"
  },
  {
    title: "Sooner or Later",
    artist: "Toni Armani",
    youtube_id: "9bZkp7q19f0",
    description: "Performance live"
  },
  {
    title: "Alté Cruise",
    artist: "Odunsi",
    youtube_id: "njBrMQDBmFk",
    description: "Boiler Room Lagos - Live"
  },
  {
    title: "2000 Excursion",
    artist: "Jackboys",
    youtube_id: "K3RCkZcwtiw",
    description: "Version live remixée"
  },
  {
    title: "Dumbo",
    artist: "Travis Scott",
    youtube_id: "XI5v_AKeYuw",
    description: "Version live avec Mike Dean"
  },
  {
    title: "Adriano",
    artist: "Niska",
    youtube_id: "TLnB1CI3SS4",
    description: "Version live remixée"
  },
  {
    title: "No More Parties",
    artist: "Coi Leray",
    youtube_id: "my2ZvqmPaco",
    description: "Version live avec Lil Durk"
  },
  {
    title: "Nouveau Boss",
    artist: "HIMRA",
    youtube_id: "i7bSdhBMcMg",
    description: "Version live mashup"
  },
  {
    title: "O'Kenneth",
    artist: "Yimaye",
    youtube_id: "wNyf_D_1O3E",
    description: "Version live collaborative"
  },
  {
    title: "WYA",
    artist: "4batz",
    youtube_id: "fECN5GY8eo0",
    description: "Version live remixée"
  }
]

# Données des chansons pour challenge_reward_videos_14 (Versions instrumentales)
songs_14 = [
  {
    title: "I Don't Believe",
    artist: "Young Thug",
    youtube_id: "jFi7WFHr09E",
    description: "Future, Young Thug - They Don't Believe Me (Remix) - remix collaboratif énergique"
  },
  {
    title: "Tu Connais",
    artist: "Werenoi",
    youtube_id: "A11kf-vT-VE",
    description: "Gazo, Werenoi - Tu Connais ft. Hamza & Rimkus (Remix) - remix collaboratif non officiel"
  },
  {
    title: "Written History",
    artist: "Lil Wayne",
    youtube_id: "TfuKgxRHQYI",
    description: "Lil Wayne & Nicki Minaj - Banned From NO (Remix) - remix parallèle du même album"
  },
  {
    title: "I Am Who I Am",
    artist: "Teddy Pendergrass",
    youtube_id: "PHQGQwx5ESM",
    description: "I Am Who I Am (Radio Edit) - version courte radio"
  },
  {
    title: "5 Star",
    artist: "Wiz Khalifa",
    youtube_id: "iiRxiGsUeCs",
    description: "Xavier Stone x Wiz Khalifa x Gunna – 5 Star Remix - remix officiel alternatif"
  },
  {
    title: "Somebody",
    artist: "Latto",
    youtube_id: "O1cJhkvjZRE",
    description: "Latto - Somebody (feat. Saweetie, Ella Mai, Nicki Minaj) Mashup - remix multi-artistes"
  },
  {
    title: "Agora Hills",
    artist: "Doja Cat",
    youtube_id: "B4hLD7vGKLk",
    description: "Doja Cat - Agora Hills (Dj Dark Remix) - remix deep house"
  },
  {
    title: "Rari",
    artist: "Kameron Carter",
    youtube_id: "Og23c78AfAA",
    description: "Lil Wayne & Kameron Carter - Rari (Best Clean Version) - version épurée"
  },
  {
    title: "Diamants et de l'or",
    artist: "Himra",
    youtube_id: "YOEoCowL2ug",
    description: "HIMRA SPÉCIAL MIX VIDEO BY SAGESSE DJ - remix DJ drill"
  },
  {
    title: "Hooch",
    artist: "Travis Scott",
    youtube_id: "nuqNGeO3u98",
    description: "Travis Scott - The Hooch (MIKE DEAN VERSION) - version studio alternative"
  }
]

# Données des chansons pour challenge_reward_videos_15 (Versions exclusives)
songs_15 = [
  {
    title: "That's the Way Love Goes",
    artist: "Janet",
    youtube_id: "wjr33w75FYw",
    description: "Janet Jackson - That´s The Way Love Goes (Funky Soul Remix) - remix soul funky qui modernise le groove original"
  },
  {
    title: "Slide",
    artist: "Calvin Harris",
    youtube_id: "vDSPAIXRkqA",
    description: "Slide - Calvin Harris ft. Frank Ocean & Migos (Jon D & Max Cover) - reprise acoustique rafraîchissante"
  },
  {
    title: "Never Tell Em Shit",
    artist: "Mozzy",
    youtube_id: "o7UVt7KUkj4",
    description: "Mozzy - IF I DIE RIGHT NOW (Official Music Video) - morceau parallèle dans la même veine"
  },
  {
    title: "Step by Step",
    artist: "Koxo",
    youtube_id: "BhFNnjzic3o",
    description: "Koxo - Step By Step (Italo-Disco 1982) - remix Italo-Disco haute qualité"
  },
  {
    title: "On the Unda",
    artist: "Larry June",
    youtube_id: "SKQSshr1LZw",
    description: "Larry June & Cardo Got Wings - On The Unda [Clean] - version épurée"
  },
  {
    title: "Little",
    artist: "Octavian",
    youtube_id: "Tbz6xQkewo4",
    description: "Mura Masa - Move Me (Official Video) ft. Octavian - collaboration exclusive"
  },
  {
    title: "Every Girl",
    artist: "Aretha Franklin",
    youtube_id: "LA2-B2y5hY8",
    description: "Mind Bob'S Mix – Aretha Franklin - remix disco rare"
  },
  {
    title: "Diana",
    artist: "DJ Snake & Hamza",
    youtube_id: "xfMXxZ1-L_0",
    description: "DJ Snake & Hamza - Diana (Official Music Video) - version officielle exclusive"
  },
  {
    title: "Lequel",
    artist: "4h44 – ZZ & Timar",
    youtube_id: "umTlEIX0GFI",
    description: "Timar feat. ZZ - Lequel #PlanèteRap - performance exclusive"
  },
  {
    title: "Bleu Soleil",
    artist: "Soleil Bleu",
    youtube_id: "gXvdmEKKQPo",
    description: "Bleu Soleil & Luiza - Soleil Bleu (Rody Gonzalez Remix) - version house chill"
  }
]

# Fonction pour créer une playlist
def create_challenge_playlist(playlist_number, songs, description)
  playlist_title = "Challenge Reward Videos #{playlist_number}"
  
  puts "\n📝 Création de la playlist : #{playlist_title}"
  puts "📄 Description : #{description}"
  
  # Vérifier si la playlist existe déjà (seulement pour les playlists 11-15)
  existing_playlist = Playlist.find_by(title: playlist_title)
  if existing_playlist && playlist_number >= 11
    puts "⚠️  La playlist '#{playlist_title}' existe déjà. Suppression..."
    
    begin
      # Supprimer d'abord les associations
      existing_playlist.videos.destroy_all
      puts "  🗑️  Vidéos supprimées"
      
      # Supprimer les associations avec les badges
      BadgePlaylistUnlock.where(playlist: existing_playlist).destroy_all
      puts "  🗑️  Associations badges supprimées"
      
      # Supprimer les associations avec les utilisateurs
      UserPlaylistUnlock.where(playlist: existing_playlist).destroy_all
      puts "  🗑️  Associations utilisateurs supprimées"
      
      # Supprimer les associations avec les récompenses (si elles existent)
      if defined?(Reward)
        Reward.where("content_type LIKE ?", "%challenge_reward_playlist_#{playlist_number}%").update_all(playlist_id: nil)
        puts "  🗑️  Associations récompenses supprimées"
      end
      
      # Maintenant supprimer la playlist
      existing_playlist.destroy
      puts "  ✅ Playlist supprimée"
    rescue => e
      puts "  ⚠️  Erreur lors de la suppression : #{e.message}"
      puts "  ℹ️  Tentative de suppression forcée..."
      begin
        existing_playlist.delete
        puts "  ✅ Playlist supprimée (méthode alternative)"
      rescue => e2
        puts "  ❌ Impossible de supprimer la playlist : #{e2.message}"
        puts "  ℹ️  Continuation avec la playlist existante..."
        return existing_playlist
      end
    end
  elsif existing_playlist && playlist_number < 11
    puts "⚠️  La playlist '#{playlist_title}' existe déjà (playlist existante). Passage à la suivante..."
    return existing_playlist
  end
  
  # Créer la nouvelle playlist
  playlist = Playlist.create!(
    title: playlist_title,
    description: description,
    genre: "Challenge",
    premium: true,
    exclusive: true,
    hidden: true  # Cachée car c'est une récompense challenge
  )
  
  puts "✅ Playlist créée avec l'ID : #{playlist.id}"
  
  # Ajouter les vidéos
  puts "\n🎵 Ajout des vidéos à la playlist..."
  
  songs.each_with_index do |song, index|
    puts "\n#{index + 1}/10 - #{song[:title]} par #{song[:artist]}"
    
    # Vérifier si la vidéo existe déjà dans cette playlist
    existing_video = playlist.videos.find_by(youtube_id: song[:youtube_id])
    if existing_video
      puts "  ⚠️  Vidéo déjà présente, mise à jour..."
      existing_video.update!(
        title: "#{song[:title]} · #{song[:artist]}",
        description: song[:description]
      )
    else
      # Créer la nouvelle vidéo
      video = playlist.videos.create!(
        title: "#{song[:title]} · #{song[:artist]}",
        youtube_id: song[:youtube_id],
        description: song[:description]
      )
      puts "  ✅ Vidéo créée avec l'ID : #{video.id}"
    end
  end
  
  # Vérification finale
  total_videos = playlist.videos.count
  puts "\n" + "=" * 40
  puts "🎉 PLAYLIST #{playlist_title.upcase} CRÉÉE AVEC SUCCÈS !"
  puts "📊 Statistiques :"
  puts "  - Titre : #{playlist.title}"
  puts "  - Description : #{playlist.description}"
  puts "  - Genre : #{playlist.genre}"
  puts "  - Nombre de vidéos : #{total_videos}"
  puts "  - ID de la playlist : #{playlist.id}"
  puts "  - Premium : #{playlist.premium?}"
  puts "  - Exclusive : #{playlist.exclusive?}"
  puts "  - Cachée : #{playlist.hidden?}"
  
  playlist
end

# Créer les playlists
playlists = []

# Playlist 11 - Remixes
playlists << create_challenge_playlist(
  11,
  songs_11,
  "Playlist exclusive de remixes débloquée via les récompenses challenge - Collection de 10 remixes exclusifs avec versions revisitées et collaborations spéciales."
)

# Playlist 12 - Versions alternatives
playlists << create_challenge_playlist(
  12,
  songs_12,
  "Playlist exclusive de versions alternatives débloquée via les récompenses challenge - Collection de 10 versions alternatives, remixes et reworks exclusifs avec des variations uniques et des collaborations spéciales."
)

# Playlist 13 - Versions live
playlists << create_challenge_playlist(
  13,
  songs_13,
  "Playlist exclusive de versions live débloquée via les récompenses challenge - Collection de 10 performances live exclusives."
)

# Playlist 14 - Versions instrumentales
playlists << create_challenge_playlist(
  14,
  songs_14,
  "Playlist exclusive de versions instrumentales débloquée via les récompenses challenge - Collection de 10 instrumentaux exclusifs."
)

# Playlist 15 - Versions exclusives
playlists << create_challenge_playlist(
  15,
  songs_15,
  "Playlist exclusive de versions exclusives débloquée via les récompenses challenge - Collection de 10 versions exclusives et rares."
)

# Intégrer dans le système de récompenses
puts "\n🔗 Intégration dans le système de récompenses..."

# Vérifier et ajouter les content_types s'ils n'existent pas
(11..15).each do |i|
  content_type = "challenge_reward_playlist_#{i}"
  puts "📋 Vérification du content_type #{content_type}..."
  
  if !Reward.content_types.key?(content_type)
    puts "⚠️  Le content_type '#{content_type}' n'existe pas encore dans le modèle Reward."
    puts "   Il faudra l'ajouter manuellement dans app/models/reward.rb"
    puts "   Ajoutez cette ligne dans l'enum content_type :"
    puts "   #{content_type}: '#{content_type}',"
  else
    puts "✅ Le content_type '#{content_type}' existe déjà."
  end
end

puts "\n✅ Script terminé avec succès !"
puts "\n🎯 Prochaines étapes :"
puts "  1. Vérifier les playlists dans l'interface admin"
puts "  2. Ajouter les content_types challenge_reward_playlist_11 à 15 dans le modèle Reward si nécessaire"
puts "  3. Intégrer les nouvelles playlists dans le système de récompenses"
puts "  4. Tester le déblocage via les récompenses challenge"
puts "  5. Vérifier l'affichage dans l'interface utilisateur"
