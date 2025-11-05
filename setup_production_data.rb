# Script pour préparer les données de production avec profils réalistes et variés
puts "🚀 Préparation des données de production..."

# Nettoyer les anciennes données
puts "🧹 Nettoyage des anciennes données..."
User.where.not(email: ['admin@example.com', 'user@example.com']).destroy_all rescue nil
Swipe.destroy_all
Game.destroy_all
Score.destroy_all
UserBadge.destroy_all
UserPlaylistUnlock.destroy_all
Reward.destroy_all

# Trouver ou créer les utilisateurs
admin = User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.password = '123456'
  user.admin = true
  user.username = 'Admin'
end
admin.update!(username: 'Admin') unless admin.username == 'Admin'

jordan = User.find_or_create_by!(email: 'user@example.com') do |user|
  user.password = '234567'
  user.username = 'Jordan'
end
jordan.update!(username: 'Jordan') unless jordan.username == 'Jordan'

driss = User.find_or_create_by!(email: 'driss@example.com') do |user|
  user.password = '345678'
  user.username = 'Driss'
end
driss.update!(username: 'Driss') unless driss.username == 'Driss'

ja = User.find_or_create_by!(email: 'ja@example.com') do |user|
  user.password = '456789'
  user.username = 'Ja'
end
ja.update!(username: 'Ja') unless ja.username == 'Ja'

users = [admin, jordan, driss, ja]
playlists = Playlist.where(premium: false).limit(15) # Plus de playlists pour varier

puts "✅ Utilisateurs trouvés/créés"

# Fonction pour créer un jeu complet avec swipes et score
def create_game_with_data(user, playlist, days_ago, score_points, likes_count, dislikes_count)
  game = Game.create!(
    user: user,
    playlist: playlist,
    created_at: days_ago.days.ago,
    updated_at: days_ago.days.ago
  )
  
  videos = playlist.videos.limit(likes_count + dislikes_count)
  videos.each_with_index do |video, index|
    action = index < likes_count ? 'like' : 'dislike'
    liked_value = action == 'like'
    Swipe.create!(
      user: user,
      video: video,
      game: game,
      playlist: playlist,
      action: action,
      liked: liked_value,
      created_at: days_ago.days.ago,
      updated_at: days_ago.days.ago
    )
  end
  
  Score.find_or_create_by!(user: user, playlist: playlist) do |score|
    score.points = score_points
    score.created_at = days_ago.days.ago
    score.updated_at = days_ago.days.ago
  end
  
  game
end

# ===========================================
# ADMIN : Joueur actif débutant (3+ badges → Challenge)
# Profil : Engagement élevé mais pas encore expert
# ===========================================
puts "\n👤 Configuration de Admin (Joueur actif débutant)..."
admin_games = []
playlists_to_play = playlists.first(8) # 8 parties
playlists_to_play.each_with_index do |playlist, index|
  days_ago = (index % 7) # Répartir sur 7 jours
  video_count = playlist.videos.count
  next if video_count == 0
  
  # Beaucoup de likes pour l'engagement
  likes = [[video_count - 1, 7].max, video_count].min
  dislikes = video_count - likes
  score_points = 380 + (index * 20) # Scores moyens
  
  game = create_game_with_data(admin, playlist, days_ago, score_points, likes, dislikes)
  admin_games << game
end

puts "  ✓ #{admin_games.count} parties créées"
puts "  ✓ Score engagement: #{admin.reload.engager_score}"
puts "  ✓ Score compétiteur: #{admin.competitor_score}"

# ===========================================
# JORDAN : Joueur compétitif (6+ badges → Exclusif)
# Profil : Meilleurs scores, beaucoup de parties
# ===========================================
puts "\n👤 Configuration de Jordan (Joueur compétitif)..."
jordan_games = []
playlists_to_play = playlists.first(12) # 12 parties (plus que Admin)
playlists_to_play.each_with_index do |playlist, index|
  days_ago = (index % 7)
  video_count = playlist.videos.count
  next if video_count == 0
  
  likes = [video_count - 2, 6].min
  dislikes = video_count - likes
  score_points = 520 + (index * 35) # MEILLEURS SCORES
  
  game = create_game_with_data(jordan, playlist, days_ago, score_points, likes, dislikes)
  jordan_games << game
end

puts "  ✓ #{jordan_games.count} parties créées"
puts "  ✓ Score compétiteur: #{jordan.reload.competitor_score}"
puts "  ✓ Score engagement: #{jordan.engager_score}"

# ===========================================
# DRISS : Critique expérimenté (9+ badges → Premium)
# Profil : Critique constructive, beaucoup de parties
# ===========================================
puts "\n👤 Configuration de Driss (Critique expérimenté)..."
driss_games = []
playlists_to_play = playlists.first(14) # 14 parties (encore plus)
playlists_to_play.each_with_index do |playlist, index|
  days_ago = (index % 7)
  video_count = playlist.videos.count
  next if video_count == 0
  
  # Dislikes modérés pour critique constructive
  dislikes = [[video_count / 2, 4].min, 3].max
  likes = video_count - dislikes
  score_points = 410 + (index * 22) # Scores moyens-bons
  
  game = create_game_with_data(driss, playlist, days_ago, score_points, likes, dislikes)
  driss_games << game
end

puts "  ✓ #{driss_games.count} parties créées"
puts "  ✓ Score critique: #{driss.reload.critic_score}"
puts "  ✓ Score compétiteur: #{driss.competitor_score}"

# ===========================================
# JA : Maître du jeu (12 badges → Ultime)
# Profil : Collection arc-en-ciel complète, le plus actif
# ===========================================
puts "\n👤 Configuration de Ja (Maître du jeu)..."
ja_games = []
playlists_to_play = playlists.first(15) # 15 parties (toutes les playlists)
playlists_to_play.each_with_index do |playlist, index|
  days_ago = (index % 7)
  video_count = playlist.videos.count
  next if video_count == 0
  
  # Mix équilibré
  likes = [video_count - 3, 5].min
  dislikes = video_count - likes
  score_points = 460 + (index * 28) # Scores très bons
  
  game = create_game_with_data(ja, playlist, days_ago, score_points, likes, dislikes)
  ja_games << game
end

puts "  ✓ #{ja_games.count} parties créées"
puts "  ✓ Score compétiteur: #{ja.reload.competitor_score}"
puts "  ✓ Score engagement: #{ja.engager_score}"
puts "  ✓ Score critique: #{ja.critic_score}"

# ===========================================
# Attribution des badges
# ===========================================
puts "\n🏆 Attribution des badges..."

users.each do |user|
  BadgeService.assign_badges(user)
  badge_count = user.user_badges.count
  puts "  ✓ #{user.username || user.email}: #{badge_count} badge(s)"
end

# Vérifier et ajuster les badges pour garantir les récompenses
admin.reload
if admin.user_badges.count < 3
  # Ajouter plus de swipes pour qu'Admin obtienne naturellement 3 badges
  extra_playlist = playlists.first
  extra_videos = extra_playlist.videos.limit(20)
  extra_videos.each do |video|
    game = admin.games.first || admin_games.first
    next unless game
    Swipe.find_or_create_by!(user: admin, video: video, game: game) do |swipe|
      swipe.action = 'like'
      swipe.liked = true
      swipe.playlist = extra_playlist
      swipe.created_at = 1.day.ago
    end
  end
  BadgeService.assign_badges(admin)
  puts "  ✓ Badges ajustés pour Admin (Challenge)"
end

jordan.reload
if jordan.user_badges.count < 6
  # Ajouter plus de swipes pour que Jordan obtienne naturellement 6 badges
  extra_playlist = playlists.first
  extra_videos = extra_playlist.videos.limit(30)
  extra_videos.each do |video|
    game = jordan.games.first || jordan_games.first
    next unless game
    Swipe.find_or_create_by!(user: jordan, video: video, game: game) do |swipe|
      swipe.action = 'like'
      swipe.liked = true
      swipe.playlist = extra_playlist
      swipe.created_at = 1.day.ago
    end
  end
  BadgeService.assign_badges(jordan)
  puts "  ✓ Badges ajustés pour Jordan (Exclusif)"
end

driss.reload
if driss.user_badges.count < 9
  # Ajouter plus de swipes pour que Driss obtienne naturellement 9 badges
  extra_playlist = playlists.first
  extra_videos = extra_playlist.videos.limit(40)
  extra_videos.each do |video|
    game = driss.games.first || driss_games.first
    next unless game
    Swipe.find_or_create_by!(user: driss, video: video, game: game) do |swipe|
      swipe.action = 'dislike'
      swipe.liked = false
      swipe.playlist = extra_playlist
      swipe.created_at = 1.day.ago
    end
  end
  BadgeService.assign_badges(driss)
  puts "  ✓ Badges ajustés pour Driss (Premium)"
end

ja.reload
if ja.user_badges.count < 12
  # Pour Ja, ajouter beaucoup de swipes pour obtenir la collection arc-en-ciel
  extra_playlist = playlists.first
  extra_videos = extra_playlist.videos.limit(50)
  extra_videos.each do |video|
    game = ja.games.first || ja_games.first
    next unless game
    Swipe.find_or_create_by!(user: ja, video: video, game: game) do |swipe|
      swipe.action = 'like'
      swipe.liked = true
      swipe.playlist = extra_playlist
      swipe.created_at = 1.day.ago
    end
  end
  # Ajouter des dislikes aussi pour diversifier
  extra_playlist.videos.limit(20).each do |video|
    game = ja.games.first || ja_games.first
    next unless game
    Swipe.find_or_create_by!(user: ja, video: video, game: game) do |swipe|
      swipe.action = 'dislike'
      swipe.liked = false
      swipe.playlist = extra_playlist
      swipe.created_at = 1.day.ago
    end
  end
  BadgeService.assign_badges(ja)
  puts "  ✓ Badges ajustés pour Ja (Ultime)"
end

# Forcer la création des récompenses (en gérant les erreurs)
puts "\n🎁 Création des récompenses..."

begin
  admin.reload
  if admin.user_badges.count >= 3 && !admin.rewards.challenge.exists?
    Reward.check_and_create_rewards_for_user(admin)
    puts "  ✓ Admin: Récompense Challenge créée"
  end
rescue => e
  puts "  ⚠ Admin: Erreur lors de la création de la récompense - #{e.message}"
end

begin
  jordan.reload
  if jordan.user_badges.count >= 6 && !jordan.rewards.exclusif.exists?
    Reward.check_and_create_rewards_for_user(jordan)
    puts "  ✓ Jordan: Récompense Exclusif créée"
  end
rescue => e
  puts "  ⚠ Jordan: Erreur lors de la création de la récompense - #{e.message}"
end

begin
  driss.reload
  if driss.user_badges.count >= 9 && !driss.rewards.premium.exists?
    Reward.check_and_create_rewards_for_user(driss)
    puts "  ✓ Driss: Récompense Premium créée"
  end
rescue => e
  puts "  ⚠ Driss: Erreur lors de la création de la récompense - #{e.message}"
end

begin
  ja.reload
  if ja.user_badges.count >= 12 && ja.has_rainbow_collection? && !ja.rewards.ultime.exists?
    Reward.check_and_create_rewards_for_user(ja)
    puts "  ✓ Ja: Récompense Ultime créée"
  end
rescue => e
  puts "  ⚠ Ja: Erreur lors de la création de la récompense - #{e.message}"
end

# ===========================================
# Déblocage des playlists de manière cohérente
# ===========================================
puts "\n🔓 Déblocage des playlists..."

premium_playlists = Playlist.where(premium: true, exclusive: [false, nil]).order(:id)

users.each do |user|
  user.reload
  if user.game_points >= 500 && premium_playlists.any?
    # Débloquer quelques playlists selon le niveau du joueur
    count = case user.username
            when 'Admin' then 3
            when 'Jordan' then 5
            when 'Driss' then 4
            when 'Ja' then 6
            else 2
            end
    
    playlists_to_unlock = premium_playlists.limit(count)
    playlists_to_unlock.each do |playlist|
      UserPlaylistUnlock.find_or_create_by!(user: user, playlist: playlist)
    end
    puts "  ✓ #{user.username}: #{user.user_playlist_unlocks.count} playlist(s) premium débloquée(s)"
  end
end

# ===========================================
# Vérification finale
# ===========================================
puts "\n📊 Vérification finale..."

users.each { |u| u.reload }

puts "\n🏆 Badges:"
users.each do |user|
  puts "  - #{user.username}: #{user.user_badges.count} badge(s)"
end

puts "\n🎁 Récompenses:"
users.each do |user|
  rewards = user.rewards
  if rewards.any?
    rewards.each do |reward|
      puts "  - #{user.username}: #{reward.reward_type} (#{reward.content_type})"
    end
  else
    puts "  - #{user.username}: Aucune récompense"
  end
end

puts "\n📈 Statistiques:"
users.each do |user|
  puts "  - #{user.username}:"
  puts "    • Parties: #{user.games.count}"
  puts "    • Swipes: #{user.swipes.count}"
  puts "    • Points (game_points): #{user.game_points}"
  puts "    • Score compétiteur: #{user.competitor_score}"
  puts "    • Score engagement: #{user.engager_score}"
  puts "    • Score critique: #{user.critic_score}"
end

puts "\n✅ Configuration terminée avec succès!"
