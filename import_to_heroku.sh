#!/bin/bash
# Script pour uploader tous les fichiers JSON et exécuter l'import sur Heroku dans un seul dyno

APP_NAME="tubenplay-app"

echo "🚀 Upload et import des données sur Heroku..."

# Exécuter tout dans un seul dyno pour éviter les problèmes d'éphémérité
cat import_complete.rb | heroku run bash -a $APP_NAME <<'HEREDOC'
# Upload des fichiers JSON et exécuter l'import dans le même dyno
cat > tmp/games_export_unique.json
HEREDOC

# Utiliser une approche différente : créer un script qui fait tout en une fois
heroku run bash -a $APP_NAME <<'ENDOFSCRIPT'
# Créer le répertoire tmp s'il n'existe pas
mkdir -p tmp

# Le script Ruby sera exécuté via rails runner avec le code inline
cat <<'RUBYCODE' | rails runner -
require 'json'

puts "📥 Import complet des données de jeu..."

# Lire les fichiers JSON depuis tmp/ (déjà uploadés dans ce dyno)
games_data = JSON.parse(File.read('tmp/games_export_unique.json'))
swipes_data = JSON.parse(File.read('tmp/swipes_export_unique.json'))
scores_data = JSON.parse(File.read('tmp/scores_export_unique.json'))
user_badges_data = JSON.parse(File.read('tmp/user_badges_export_unique.json'))
users_data = JSON.parse(File.read('tmp/users_export.json'))

puts "✅ Données chargées:"
puts "  - #{games_data.count} parties"
puts "  - #{swipes_data.count} swipes"
puts "  - #{scores_data.count} scores"
puts "  - #{user_badges_data.count} badges utilisateurs"
puts "  - #{users_data.count} utilisateurs"

# 1. Mettre à jour les utilisateurs
puts "\n👤 Mise à jour des utilisateurs..."
users_updated = 0
users_data.each do |user_data|
  user = User.find_by(email: user_data['email'])
  if user
    user.update!(
      points: user_data['points'] || 0,
      vip_subscription: user_data['vip_subscription'] || false,
      vip_expires_at: user_data['vip_expires_at'] ? Time.parse(user_data['vip_expires_at']) : nil,
      admin: user_data['admin'] || false
    )
    users_updated += 1
    puts "  ✅ #{user.email}: #{user.points || 0} points, VIP: #{user.vip_subscription}"
  else
    puts "  ⚠️  Utilisateur #{user_data['email']} non trouvé sur Heroku"
  end
end
puts "✅ #{users_updated} utilisateurs mis à jour"

# 2. Import des games
puts "\n🎮 Import des parties..."
games_imported = 0
games_skipped = 0
games_data.each do |game_data|
  user = User.find_by(email: game_data['user_email'])
  playlist = Playlist.find_by(title: game_data['playlist_title'])
  
  if user && playlist
    game = Game.find_or_create_by!(
      user_id: user.id,
      playlist_id: playlist.id
    ) do |g|
      g.completed_at = game_data['completed_at'] ? Time.parse(game_data['completed_at']) : nil
      g.created_at = Time.parse(game_data['created_at'])
      g.updated_at = Time.parse(game_data['updated_at'])
    end
    game.update!(
      completed_at: game_data['completed_at'] ? Time.parse(game_data['completed_at']) : nil,
      created_at: Time.parse(game_data['created_at']),
      updated_at: Time.parse(game_data['updated_at'])
    )
    games_imported += 1
  else
    games_skipped += 1
    puts "  ⚠️  Partie ignorée: user=#{game_data['user_email']}, playlist=#{game_data['playlist_title']}"
  end
end
puts "✅ #{games_imported} parties importées (#{games_skipped} ignorées)"

# 3. Import des scores
puts "\n📊 Import des scores..."
scores_imported = 0
scores_skipped = 0
scores_data.each do |score_data|
  user = User.find_by(email: score_data['user_email'])
  playlist = Playlist.find_by(title: score_data['playlist_title'])
  
  if user && playlist
    score = Score.find_or_create_by!(
      user_id: user.id,
      playlist_id: playlist.id
    ) do |s|
      s.points = score_data['points']
      s.created_at = Time.parse(score_data['created_at'])
      s.updated_at = Time.parse(score_data['updated_at'])
    end
    score.update!(
      points: score_data['points'],
      created_at: Time.parse(score_data['created_at']),
      updated_at: Time.parse(score_data['updated_at'])
    )
    scores_imported += 1
  else
    scores_skipped += 1
  end
end
puts "✅ #{scores_imported} scores importés (#{scores_skipped} ignorés)"

# 4. Import des user_badges
puts "\n🏆 Import des badges utilisateurs..."
badges_imported = 0
badges_skipped = 0
user_badges_data.each do |ub_data|
  user = User.find_by(email: ub_data['user_email'])
  badge = Badge.find_by(name: ub_data['badge_name'])
  
  if user && badge
    user_badge = UserBadge.find_or_create_by!(
      user_id: user.id,
      badge_id: badge.id
    ) do |ub|
      ub.earned_at = ub_data['earned_at'] ? Time.parse(ub_data['earned_at']) : nil
      ub.points_at_earned = ub_data['points_at_earned']
      ub.claimed_at = ub_data['claimed_at'] ? Time.parse(ub_data['claimed_at']) : nil
      ub.created_at = Time.parse(ub_data['created_at'])
      ub.updated_at = Time.parse(ub_data['updated_at'])
    end
    user_badge.update!(
      earned_at: ub_data['earned_at'] ? Time.parse(ub_data['earned_at']) : nil,
      points_at_earned: ub_data['points_at_earned'],
      claimed_at: ub_data['claimed_at'] ? Time.parse(ub_data['claimed_at']) : nil,
      created_at: Time.parse(ub_data['created_at']),
      updated_at: Time.parse(ub_data['updated_at'])
    )
    badges_imported += 1
  else
    badges_skipped += 1
    puts "  ⚠️  Badge ignoré: user=#{ub_data['user_email']}, badge=#{ub_data['badge_name']}" unless user && badge
  end
end
puts "✅ #{badges_imported} badges utilisateurs importés (#{badges_skipped} ignorés)"

# 5. Import des swipes
puts "\n👆 Import des swipes..."
swipes_imported = 0
swipes_skipped = 0
swipes_data.each do |swipe_data|
  user = User.find_by(email: swipe_data['user_email'])
  playlist = Playlist.find_by(title: swipe_data['playlist_title'])
  video = Video.find_by(youtube_id: swipe_data['video_youtube_id'])
  
  if user && playlist && video
    game = Game.find_by(user_id: user.id, playlist_id: playlist.id)
    
    if game
      swipe = Swipe.find_or_create_by!(
        user_id: user.id,
        video_id: video.id,
        game_id: game.id
      ) do |s|
        s.liked = swipe_data['liked']
        s.action = swipe_data['action']
        s.playlist_id = playlist.id
        s.created_at = Time.parse(swipe_data['created_at'])
        s.updated_at = Time.parse(swipe_data['updated_at'])
      end
      swipe.update!(
        liked: swipe_data['liked'],
        action: swipe_data['action'],
        playlist_id: playlist.id,
        created_at: Time.parse(swipe_data['created_at']),
        updated_at: Time.parse(swipe_data['updated_at'])
      )
      swipes_imported += 1
    else
      swipes_skipped += 1
    end
  else
    swipes_skipped += 1
  end
end
puts "✅ #{swipes_imported} swipes importés (#{swipes_skipped} ignorés)"

puts "\n🎉 Import terminé !"
puts "\n📊 Résumé final:"
puts "  - Utilisateurs mis à jour: #{users_updated}"
puts "  - Parties: #{games_imported}"
puts "  - Scores: #{scores_imported}"
puts "  - Badges: #{badges_imported}"
puts "  - Swipes: #{swipes_imported}"
RUBYCODE
ENDOFSCRIPT

echo "✅ Import terminé !"

