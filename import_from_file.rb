#!/usr/bin/env ruby
# Script pour importer les données depuis un fichier
# Usage: heroku run "rails runner import_from_file.rb" -a app
# Le fichier doit être dans /tmp/all_data.json

require 'json'

puts "📥 Import des données de jeu depuis /tmp/all_data.json..."

# Lire les données depuis le fichier
unless File.exist?('/tmp/all_data.json')
  puts "❌ Fichier /tmp/all_data.json non trouvé"
  exit 1
end

input = File.read('/tmp/all_data.json')
data = JSON.parse(input)

# Séparer les données par type
games_data = data['games'] || []
swipes_data = data['swipes'] || []
scores_data = data['scores'] || []
user_badges_data = data['user_badges'] || []
users_data = data['users'] || []

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
    Game.find_or_create_by!(
      user_id: user.id,
      playlist_id: playlist.id
    ) do |g|
      g.completed_at = game_data['completed_at'] ? Time.parse(game_data['completed_at']) : nil
      g.created_at = Time.parse(game_data['created_at'])
      g.updated_at = Time.parse(game_data['updated_at'])
    end
    games_imported += 1
  else
    games_skipped += 1
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
    Score.find_or_create_by!(
      user_id: user.id,
      playlist_id: playlist.id
    ) do |s|
      s.points = score_data['points']
      s.created_at = Time.parse(score_data['created_at'])
      s.updated_at = Time.parse(score_data['updated_at'])
    end
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
    UserBadge.find_or_create_by!(
      user_id: user.id,
      badge_id: badge.id
    ) do |ub|
      ub.earned_at = ub_data['earned_at'] ? Time.parse(ub_data['earned_at']) : nil
      ub.points_at_earned = ub_data['points_at_earned']
      ub.claimed_at = ub_data['claimed_at'] ? Time.parse(ub_data['claimed_at']) : nil
      ub.created_at = Time.parse(ub_data['created_at'])
      ub.updated_at = Time.parse(ub_data['updated_at'])
    end
    badges_imported += 1
  else
    badges_skipped += 1
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
      Swipe.find_or_create_by!(
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

