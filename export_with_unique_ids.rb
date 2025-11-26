# Export avec identifiants uniques pour faciliter l'import
puts '📤 Export des données avec identifiants uniques...'

# Export des games avec email et titre de playlist
games_data = Game.includes(:user, :playlist).map do |g|
  {
    user_email: g.user.email,
    playlist_title: g.playlist.title,
    completed_at: g.completed_at,
    created_at: g.created_at,
    updated_at: g.updated_at
  }
end
File.write('tmp/games_export_unique.json', games_data.to_json)
puts "✅ #{games_data.count} parties exportées"

# Export des swipes avec email, titre de playlist et youtube_id
swipes_data = Swipe.includes(:user, :playlist, :video).map do |s|
  {
    user_email: s.user.email,
    playlist_title: s.playlist.title,
    video_youtube_id: s.video.youtube_id,
    liked: s.liked,
    action: s.action,
    created_at: s.created_at,
    updated_at: s.updated_at
  }
end
File.write('tmp/swipes_export_unique.json', swipes_data.to_json)
puts "✅ #{swipes_data.count} swipes exportés"

# Export des scores avec email et titre de playlist
scores_data = Score.includes(:user, :playlist).map do |s|
  {
    user_email: s.user.email,
    playlist_title: s.playlist.title,
    points: s.points,
    created_at: s.created_at,
    updated_at: s.updated_at
  }
end
File.write('tmp/scores_export_unique.json', scores_data.to_json)
puts "✅ #{scores_data.count} scores exportés"

# Export des user_badges avec email et nom de badge
user_badges_data = UserBadge.includes(:user, :badge).map do |ub|
  {
    user_email: ub.user.email,
    badge_name: ub.badge.name,
    earned_at: ub.earned_at,
    points_at_earned: ub.points_at_earned,
    claimed_at: ub.claimed_at,
    created_at: ub.created_at,
    updated_at: ub.updated_at
  }
end
File.write('tmp/user_badges_export_unique.json', user_badges_data.to_json)
puts "✅ #{user_badges_data.count} badges utilisateurs exportés"

puts '🎉 Export terminé avec identifiants uniques !'
