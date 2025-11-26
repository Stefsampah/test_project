#!/bin/bash
# Script final pour importer les données sur Heroku
# Utilise une seule commande heroku run pour tout faire

APP_NAME="tubenplay-app"

echo "🚀 Import des données sur Heroku dans un seul dyno..."

# Utiliser une seule commande bash qui lit le JSON depuis stdin,
# puis exécute le script Ruby inline
cat tmp/all_data.json | heroku run "bash -c 'cat > /tmp/all_data.json && rails runner \"
require \\\"json\\\"
input = File.read(\\\"/tmp/all_data.json\\\")
data = JSON.parse(input)
games_data = data[\\\"games\\\"] || []
swipes_data = data[\\\"swipes\\\"] || []
scores_data = data[\\\"scores\\\"] || []
user_badges_data = data[\\\"user_badges\\\"] || []
users_data = data[\\\"users\\\"] || []
puts \\\"✅ Données chargées: #{games_data.count} parties, #{swipes_data.count} swipes, #{scores_data.count} scores, #{user_badges_data.count} badges, #{users_data.count} utilisateurs\\\"
users_updated = 0
users_data.each { |u| user = User.find_by(email: u[\\\"email\\\"]); if user; user.update!(points: u[\\\"points\\\"] || 0, vip_subscription: u[\\\"vip_subscription\\\"] || false, vip_expires_at: u[\\\"vip_expires_at\\\"] ? Time.parse(u[\\\"vip_expires_at\\\"]) : nil, admin: u[\\\"admin\\\"] || false); users_updated += 1; puts \\\"  ✅ #{user.email}: #{user.points || 0} points\\\"; end }
puts \\\"✅ #{users_updated} utilisateurs mis à jour\\\"
games_imported = 0
games_data.each { |g| user = User.find_by(email: g[\\\"user_email\\\"]); playlist = Playlist.find_by(title: g[\\\"playlist_title\\\"]); if user && playlist; Game.find_or_create_by!(user_id: user.id, playlist_id: playlist.id) { |game| game.completed_at = g[\\\"completed_at\\\"] ? Time.parse(g[\\\"completed_at\\\"]) : nil; game.created_at = Time.parse(g[\\\"created_at\\\"]); game.updated_at = Time.parse(g[\\\"updated_at\\\"]); }; games_imported += 1; end }
puts \\\"✅ #{games_imported} parties importées\\\"
scores_imported = 0
scores_data.each { |s| user = User.find_by(email: s[\\\"user_email\\\"]); playlist = Playlist.find_by(title: s[\\\"playlist_title\\\"]); if user && playlist; Score.find_or_create_by!(user_id: user.id, playlist_id: playlist.id) { |score| score.points = s[\\\"points\\\"]; score.created_at = Time.parse(s[\\\"created_at\\\"]); score.updated_at = Time.parse(s[\\\"updated_at\\\"]); }; scores_imported += 1; end }
puts \\\"✅ #{scores_imported} scores importés\\\"
badges_imported = 0
user_badges_data.each { |ub| user = User.find_by(email: ub[\\\"user_email\\\"]); badge = Badge.find_by(name: ub[\\\"badge_name\\\"]); if user && badge; UserBadge.find_or_create_by!(user_id: user.id, badge_id: badge.id) { |ub_record| ub_record.earned_at = ub[\\\"earned_at\\\"] ? Time.parse(ub[\\\"earned_at\\\"]) : nil; ub_record.points_at_earned = ub[\\\"points_at_earned\\\"]; ub_record.claimed_at = ub[\\\"claimed_at\\\"] ? Time.parse(ub[\\\"claimed_at\\\"]) : nil; ub_record.created_at = Time.parse(ub[\\\"created_at\\\"]); ub_record.updated_at = Time.parse(ub[\\\"updated_at\\\"]); }; badges_imported += 1; end }
puts \\\"✅ #{badges_imported} badges importés\\\"
swipes_imported = 0
swipes_data.each { |sw| user = User.find_by(email: sw[\\\"user_email\\\"]); playlist = Playlist.find_by(title: sw[\\\"playlist_title\\\"]); video = Video.find_by(youtube_id: sw[\\\"video_youtube_id\\\"]); if user && playlist && video; game = Game.find_by(user_id: user.id, playlist_id: playlist.id); if game; Swipe.find_or_create_by!(user_id: user.id, video_id: video.id, game_id: game.id) { |s| s.liked = sw[\\\"liked\\\"]; s.action = sw[\\\"action\\\"]; s.playlist_id = playlist.id; s.created_at = Time.parse(sw[\\\"created_at\\\"]); s.updated_at = Time.parse(sw[\\\"updated_at\\\"]); }; swipes_imported += 1; end; end }
puts \\\"✅ #{swipes_imported} swipes importés\\\"
puts \\\"🎉 Import terminé !\\\"
\"" -a $APP_NAME

echo ""
echo "🎉 Import terminé !"

