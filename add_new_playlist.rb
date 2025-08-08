#!/usr/bin/env ruby

# Script pour ajouter une nouvelle playlist challenge_reward_videos_10 avec les 10 chansons fournies
puts "🎵 Création de la playlist challenge_reward_videos_10"
puts "=" * 60

# Données des chansons pour challenge_reward_videos_10
songs = [
  {
    title: "Help Me Find My Drawls",
    artist: "Tonio Armani",
    youtube_id: "5q5HzkETh9E",
    description: "Live version à Columbus GA"
  },
  {
    title: "Joy",
    artist: "Snoop Dogg",
    youtube_id: "1Xhx1et1PTI",
    description: "Version officielle"
  },
  {
    title: "My Mind Playin Tricks on Me",
    artist: "Geto Boys",
    youtube_id: "FnPGwvvot3g",
    description: "Classic hip-hop track"
  },
  {
    title: "Funk Pop Type Beat (feels)",
    artist: "dannyebtracks",
    youtube_id: "4q3khHysVpM",
    description: "Version disco-funk : JORDAN 1"
  },
  {
    title: "Rapid Fire",
    artist: "Cruel Santino",
    youtube_id: "UYnt869NR80",
    description: "Alte Type Beat inspiré de Rapid Fire"
  },
  {
    title: "White Noise",
    artist: "Joyner Lucas",
    youtube_id: "y-YAnyGzJY8",
    description: "Instrumental disponible sur YouTube Music"
  },
  {
    title: "Fuego",
    artist: "Manu Crooks & Anfa Rose",
    youtube_id: "u7i9oCgsukE",
    description: "Clip officiel"
  },
  {
    title: "Mary Jane (All Night Long)",
    artist: "Mary J. Blige",
    youtube_id: "XWP9LWeE0-I", # ID corrigé pour Mary J. Blige
    description: "Versions alternatives sur Discogs"
  },
  {
    title: "Cowgirl Trailride (feat. Tonio Armani)",
    artist: "S Dott",
    youtube_id: "XbrMlV2qur8",
    description: "Version live à Atlanta"
  },
  {
    title: "Go Anywhere",
    artist: "Sally Green",
    youtube_id: "2OMK7sQd-Qk",
    description: "Version officielle avec Kurupt"
  }
]

# Créer la playlist challenge_reward_videos_10
playlist_title = "Challenge Reward Videos 10"
playlist_description = "Playlist exclusive débloquée via les récompenses challenge - Collection spéciale de 10 titres hip-hop et R&B. Inclut des versions live, des instrumentaux et des collaborations exclusives."

puts "\n📝 Création de la playlist : #{playlist_title}"
puts "📄 Description : #{playlist_description}"

# Vérifier si la playlist existe déjà
existing_playlist = Playlist.find_by(title: playlist_title)
if existing_playlist
  puts "⚠️  La playlist '#{playlist_title}' existe déjà. Suppression..."
  existing_playlist.destroy
end

# Créer la nouvelle playlist
playlist = Playlist.create!(
  title: playlist_title,
  description: playlist_description,
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
puts "\n" + "=" * 60
puts "🎉 PLAYLIST CHALLENGE_REWARD_VIDEOS_10 CRÉÉE AVEC SUCCÈS !"
puts "📊 Statistiques :"
puts "  - Titre : #{playlist.title}"
puts "  - Description : #{playlist.description}"
puts "  - Genre : #{playlist.genre}"
puts "  - Nombre de vidéos : #{total_videos}"
puts "  - ID de la playlist : #{playlist.id}"
puts "  - Premium : #{playlist.premium?}"
puts "  - Exclusive : #{playlist.exclusive?}"
puts "  - Cachée : #{playlist.hidden?}"

# Afficher toutes les vidéos de la playlist
puts "\n📋 Liste des vidéos dans la playlist :"
playlist.videos.order(:id).each_with_index do |video, index|
  puts "  #{index + 1}. #{video.title}"
  puts "     YouTube ID : #{video.youtube_id}"
  puts "     Description : #{video.description}"
  puts ""
end

# Intégrer dans le système de récompenses
puts "\n🔗 Intégration dans le système de récompenses..."

# Vérifier si le content_type challenge_reward_playlist_10 existe dans le modèle Reward
puts "📋 Vérification du content_type challenge_reward_playlist_10..."

# Ajouter le content_type s'il n'existe pas
if !Reward.content_types.key?('challenge_reward_playlist_10')
  puts "⚠️  Le content_type 'challenge_reward_playlist_10' n'existe pas encore dans le modèle Reward."
  puts "   Il faudra l'ajouter manuellement dans app/models/reward.rb"
  puts "   Ajoutez cette ligne dans l'enum content_type :"
  puts "   challenge_reward_playlist_10: 'challenge_reward_playlist_10',"
else
  puts "✅ Le content_type 'challenge_reward_playlist_10' existe déjà."
end

puts "\n✅ Script terminé avec succès !"
puts "\n🎯 Prochaines étapes :"
puts "  1. Vérifier la playlist dans l'interface admin"
puts "  2. Ajouter le content_type challenge_reward_playlist_10 dans le modèle Reward si nécessaire"
puts "  3. Tester la lecture des vidéos"
puts "  4. Intégrer la playlist dans le système de récompenses"
puts "  5. Tester le déblocage via les récompenses challenge"
