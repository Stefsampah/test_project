# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Création d'un utilisateur admin
admin = User.find_or_create_by!(email: 'admin@example.com') do |user|
    user.password = '123456'
    user.admin = true
  end
  
  # Création d'un utilisateur normal
  user = User.find_or_create_by!(email: 'user@example.com') do |user|
    user.password = '234567'
  end
  
  # Playlist 1: Musique Pop
  pop_playlist = Playlist.find_or_create_by!(title: 'Top Pop Hits 2024') do |playlist|
    playlist.description = 'Les meilleurs hits pop du moment'
  end
  
  # Vidéos pour la playlist Pop
  pop_videos = [
    { title: 'Dua Lipa - Houdini', youtube_id: 'suAR1PYFNYA' },
    { title: 'Tate McRae - Greedy', youtube_id: 'To4SWGZkEPk' },
    { title: 'Doja Cat - Paint The Town Red', youtube_id: 'm4_9TFeMfJE' },
    { title: 'Olivia Rodrigo - vampire', youtube_id: 'RlPNh_PBZb4' },
    { title: 'Billie Eilish - What Was I Made For?', youtube_id: 'cW8VLC9nnTo' },
    { title: 'Miley Cyrus - Flowers', youtube_id: 'G7KNmW9a75Y' },
    { title: 'SZA - Kill Bill', youtube_id: 'MSRcC626prw' },
    { title: 'Taylor Swift - Anti-Hero', youtube_id: 'b1kbLwvqugk' },
    { title: 'The Weeknd - Die For You', youtube_id: 'uPD0QOGTmMI' },
    { title: 'Ed Sheeran - Eyes Closed', youtube_id: 'u6wOyMUs74I' }
  ]
  
  pop_videos.each do |video|
    pop_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
  # Playlist 2: Hip Hop
  hip_hop_playlist_1 = Playlist.find_or_create_by!(title: 'Best Hip Hop Music') do |playlist|
    playlist.description = 'Les meilleurs morceaux de hip hop'
  end
  
  # Vidéos pour la playlist Hip Hop
  hip_hop_videos_1 = [
    { title: 'ENTRE NOUS DEUX · Didi B · Doupi Papillon', youtube_id: 'qMNl8T42krY' },
    { title: 'Nothing Without God · POPCAAN', youtube_id: 'wFRyzB170sk' },
    { title: 'HIMRA - NUMBER ONE (FT. MINZ)', youtube_id: 'b16_UBiP4G0' },
    { title: 'Travis Scott - She Going Dumb', youtube_id: 'tN82cGi9kUc' },
    { title: 'Quavo, Lil Baby - Legends', youtube_id: '4cCzuTQ49V8' },
    { title: 'Skillibeng - New Gears', youtube_id: 'Yubuf7k1WZM' },
    { title: 'TOUT VA BIEN · Didi B', youtube_id: 'WdwasPVKGQo' },
    { title: 'Toosii - Party Girl Anthem', youtube_id: 'x4xDmrvHTY0' },
    { title: 'YE - CIRCLES', youtube_id: 'SWPeFW7Bd74' },
    { title: 'Didi B - Good vibes', youtube_id: 'wLdtn45riSc' }
  ]
  
  
  hip_hop_videos_1.each do |video|
    hip_hop_playlist_1.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
# Playlist 3: Hip Hop 2
hip_hop_playlist_2 = Playlist.find_or_create_by!(title: 'Best Hip Hop Music Vol. 2') do |playlist|
  playlist.description = 'Encore plus de hip hop !'
end

# Vidéos pour la playlist Hip Hop 2
hip_hop_videos_2 = [
    { title: 'ENTRE NOUS DEUX · Didi B · Doupi Papillon', youtube_id: 'qMNl8T42krY' },
    { title: 'Nothing Without God · POPCAAN', youtube_id: 'wFRyzB170sk' },
    { title: 'HIMRA - NUMBER ONE (FT. MINZ)', youtube_id: 'b16_UBiP4G0' },
    { title: 'Travis Scott - She Going Dumb', youtube_id: 'tN82cGi9kUc' },
    { title: 'Quavo, Lil Baby - Legends', youtube_id: '4cCzuTQ49V8' },
    { title: 'Skillibeng - New Gears', youtube_id: 'Yubuf7k1WZM' },
    { title: 'TOUT VA BIEN · Didi B', youtube_id: 'WdwasPVKGQo' },
    { title: 'Toosii - Party Girl Anthem', youtube_id: 'x4xDmrvHTY0' },
    { title: 'YE - CIRCLES', youtube_id: 'SWPeFW7Bd74' },
    { title: 'Didi B - Good vibes', youtube_id: 'wLdtn45riSc' }
  ]
  
  
  hip_hop_videos_2.each do |video|
    hip_hop_playlist_2.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end


  # Playlist 3: Reggae
  reggae_playlist = Playlist.find_or_create_by!(title: 'Best Reggae Hits') do |playlist|
    playlist.description = 'Les meilleurs morceaux de reggae'
  end
  
  # Vidéos pour la playlist Reggae
  reggae_videos = [
    { title: 'Bob Marley - No Woman No Cry', youtube_id: 'IT8XvzIfi4U' },  
    { title: 'UB40 - Red Red Wine', youtube_id: 'zXt56MB-3vc' },
    { title: 'Bob Marley - Three Little Birds', youtube_id: 'HNBCVM4KbUM' },  
    { title: 'Damian Marley - Welcome To Jamrock', youtube_id: '_GZlJGERbvE' },
    { title: 'Bob Marley - Jamming', youtube_id: 'oqVy6eRXc7Q' },
    { title: 'UB40 - Kingston Town', youtube_id: '4zL3Cf5xrOo' },
    { title: 'Bob Marley - One Love', youtube_id: 'IN0KkGeEURw' },
    { title: 'Inner Circle - Sweat', youtube_id: 'f7OXGANW9Ic' }, 
    { title: 'Bob Marley - Could You Be Loved', youtube_id: '1ti2YCFgCoI' },
    { title: 'UB40 - Can\'t Help Falling In Love', youtube_id: 'jzgQh223MYk' }
  ]
  
  reggae_videos.each do |video|
    reggae_playlist.videos.find_or_create_by!(youtube_id: video[:youtube_id]) do |v|
      v.title = video[:title]
    end
  end
  
  # Création de quelques scores pour tester
  Score.find_or_create_by!(user: user, playlist: pop_playlist) do |score|
    score.points = 7
  end
  
  Score.find_or_create_by!(user: user, playlist: hip_hop_playlist_1) do |score|
    score.points = 5
  end
  
  Score.find_or_create_by!(user: user, playlist: reggae_playlist) do |score|
    score.points = 8
  end
  
  Score.find_or_create_by!(user: admin, playlist: pop_playlist) do |score|
    score.points = 9
  end
  
  Score.find_or_create_by!(user: admin, playlist: hip_hop_playlist_1) do |score|
    score.points = 6
  end
  
  Score.find_or_create_by!(user: admin, playlist: reggae_playlist) do |score|
    score.points = 7
  end
  
  # Badges Seeds
  # Competitor Badges
  [
    {
      name: 'Bronze Competitor',
      badge_type: 'competitor',
      level: 'bronze',
      points_required: 1000,
      description: 'A solid start in the competition!',
      reward_type: 'standard',
      reward_description: 'Access to exclusive playlists'
    },
    {
      name: 'Silver Competitor',
      badge_type: 'competitor',
      level: 'silver',
      points_required: 3000,
      description: 'You\'re becoming a force to be reckoned with!',
      reward_type: 'standard',
      reward_description: 'Photos dédicacées'
    },
    {
      name: 'Gold Competitor',
      badge_type: 'competitor',
      level: 'gold',
      points_required: 5000,
      description: 'A true champion of the competition!',
      reward_type: 'premium',
      reward_description: 'Invitation à un concert VIP'
    }
  ].each do |badge_attrs|
    Badge.find_or_create_by!(badge_type: badge_attrs[:badge_type], level: badge_attrs[:level]) do |badge|
      badge.name = badge_attrs[:name]
      badge.points_required = badge_attrs[:points_required]
      badge.description = badge_attrs[:description]
      badge.reward_type = badge_attrs[:reward_type]
      badge.reward_description = badge_attrs[:reward_description]
    end
  end
  
  # Engager Badges
  [
    {
      name: 'Bronze Engager',
      badge_type: 'engager',
      level: 'bronze',
      points_required: 500,
      description: 'You\'re starting to make your mark!',
      reward_type: 'standard',
      reward_description: 'Accès anticipé à des playlists'
    },
    {
      name: 'Silver Engager',
      badge_type: 'engager',
      level: 'silver',
      points_required: 1500,
      description: 'Your engagement is making waves!',
      reward_type: 'standard',
      reward_description: 'Photos dédicacées'
    },
    {
      name: 'Gold Engager',
      badge_type: 'engager',
      level: 'gold',
      points_required: 3000,
      description: 'You\'re the heart of the community!',
      reward_type: 'premium',
      reward_description: 'Rencontre avec un artiste'
    }
  ].each do |badge_attrs|
    Badge.find_or_create_by!(badge_type: badge_attrs[:badge_type], level: badge_attrs[:level]) do |badge|
      badge.name = badge_attrs[:name]
      badge.points_required = badge_attrs[:points_required]
      badge.description = badge_attrs[:description]
      badge.reward_type = badge_attrs[:reward_type]
      badge.reward_description = badge_attrs[:reward_description]
    end
  end
  
  # Critic Badges
  [
    {
      name: 'Bronze Critic',
      badge_type: 'critic',
      level: 'bronze',
      points_required: 500,
      description: 'Your opinions are valued!',
      reward_type: 'standard',
      reward_description: 'Accès à du contenu exclusif'
    },
    {
      name: 'Silver Critic',
      badge_type: 'critic',
      level: 'silver',
      points_required: 2000,
      description: 'Your taste is impeccable!',
      reward_type: 'standard',
      reward_description: 'Photos dédicacées'
    },
    {
      name: 'Gold Critic',
      badge_type: 'critic',
      level: 'gold',
      points_required: 4000,
      description: 'You\'re a true connoisseur!',
      reward_type: 'premium',
      reward_description: 'Participation à des interviews live'
    }
  ].each do |badge_attrs|
    Badge.find_or_create_by!(badge_type: badge_attrs[:badge_type], level: badge_attrs[:level]) do |badge|
      badge.name = badge_attrs[:name]
      badge.points_required = badge_attrs[:points_required]
      badge.description = badge_attrs[:description]
      badge.reward_type = badge_attrs[:reward_type]
      badge.reward_description = badge_attrs[:reward_description]
    end
  end
  
  # Challenger Badges
  [
    {
      name: 'Bronze Challenger',
      badge_type: 'challenger',
      level: 'bronze',
      points_required: 2500,
      description: 'You\'re climbing the ranks!',
      reward_type: 'standard',
      reward_description: 'Accès anticipé à du contenu exclusif'
    },
    {
      name: 'Silver Challenger',
      badge_type: 'challenger',
      level: 'silver',
      points_required: 5000,
      description: 'You\'re a formidable opponent!',
      reward_type: 'standard',
      reward_description: 'Merchandising exclusif'
    },
    {
      name: 'Gold Challenger',
      badge_type: 'challenger',
      level: 'gold',
      points_required: 7000,
      description: 'You\'re the ultimate champion!',
      reward_type: 'premium',
      reward_description: 'Invitation à un concert VIP'
    }
  ].each do |badge_attrs|
    Badge.find_or_create_by!(badge_type: badge_attrs[:badge_type], level: badge_attrs[:level]) do |badge|
      badge.name = badge_attrs[:name]
      badge.points_required = badge_attrs[:points_required]
      badge.description = badge_attrs[:description]
      badge.reward_type = badge_attrs[:reward_type]
      badge.reward_description = badge_attrs[:reward_description]
    end
  end
  
  # Users Seeds
  # Création des utilisateurs de test
  driss = User.find_or_create_by!(email: 'driss@example.com') do |user|
    user.password = '123456'
    user.username = 'Driss'
  end
  
  theo = User.find_or_create_by!(email: 'theo@example.com') do |user|
    user.password = '123456'
    user.username = 'Théo'
  end
  
  vb = User.find_or_create_by!(email: 'vb@example.com') do |user|
    user.password = '123456'
    user.username = 'VB'
  end
  
  # Scores pour Driss (Competitor)
  pop_playlist.scores.find_or_create_by!(user: driss) do |score|
    score.points = 950
  end
  
  hip_hop_playlist_1.scores.find_or_create_by!(user: driss) do |score|
    score.points = 850
  end
  
  reggae_playlist.scores.find_or_create_by!(user: driss) do |score|
    score.points = 900
  end
  
  # Swipes pour Driss
  # Créons d'abord un jeu pour Driss
  driss_game = Game.find_or_create_by!(user: driss, playlist: pop_playlist)

  pop_playlist.videos.each do |video|
    Swipe.find_or_create_by!(user: driss, video: video, game: driss_game) do |swipe|
      swipe.action = 'like'
      swipe.liked = true
      swipe.playlist = pop_playlist
    end
  end
  
  # Scores pour Théo (Engager)
  pop_playlist.scores.find_or_create_by!(user: theo) do |score|
    score.points = 400
  end
  
  hip_hop_playlist_1.scores.find_or_create_by!(user: theo) do |score|
    score.points = 350
  end
  
  reggae_playlist.scores.find_or_create_by!(user: theo) do |score|
    score.points = 380
  end
  
  # Swipes pour Théo
  # Créons d'abord un jeu pour Théo
  theo_game = Game.find_or_create_by!(user: theo, playlist: pop_playlist)

  pop_playlist.videos.each do |video|
    action = ['like', 'dislike'].sample
    Swipe.find_or_create_by!(user: theo, video: video, game: theo_game) do |swipe|
      swipe.action = action
      swipe.liked = (action == 'like')
      swipe.playlist = pop_playlist
    end
  end
  
  # Scores pour VB (Challenger)
  pop_playlist.scores.find_or_create_by!(user: vb) do |score|
    score.points = 2000
  end
  
  hip_hop_playlist_1.scores.find_or_create_by!(user: vb) do |score|
    score.points = 1800
  end
  
  reggae_playlist.scores.find_or_create_by!(user: vb) do |score|
    score.points = 1900
  end
  
  # Swipes pour VB
  # Créons d'abord un jeu pour VB
  vb_game = Game.find_or_create_by!(user: vb, playlist: pop_playlist)

  pop_playlist.videos.each do |video|
    Swipe.find_or_create_by!(user: vb, video: video, game: vb_game) do |swipe|
      swipe.action = 'like'
      swipe.liked = true
      swipe.playlist = pop_playlist
    end
  end
  
  # Création des badges
  # Badges pour The Competitor
  Badge.find_or_create_by!(badge_type: "competitor", level: "bronze") do |badge|
    badge.name = "Bronze Competitor"
    badge.points_required = 100
    badge.description = "Vous commencez à vous faire remarquer dans les compétitions"
    badge.reward_type = "standard"
    badge.reward_description = "Accès à une playlist exclusive"
  end
  
  Badge.find_or_create_by!(badge_type: "competitor", level: "silver") do |badge|
    badge.name = "Silver Competitor"
    badge.points_required = 500
    badge.description = "Vous êtes un compétiteur redoutable"
    badge.reward_type = "premium"
    badge.reward_description = "Accès à des playlists premium"
  end
  
  Badge.find_or_create_by!(badge_type: "competitor", level: "gold") do |badge|
    badge.name = "Gold Competitor"
    badge.points_required = 1000
    badge.description = "Vous êtes un champion incontesté"
    badge.reward_type = "premium"
    badge.reward_description = "Accès VIP à toutes les playlists"
  end
  
  # Badges pour The Engager
  Badge.find_or_create_by!(badge_type: "engager", level: "bronze") do |badge|
    badge.name = "Bronze Engager"
    badge.points_required = 50
    badge.description = "Vous commencez à vous engager activement"
    badge.reward_type = "standard"
    badge.reward_description = "Accès à des statistiques détaillées"
  end
  
  Badge.find_or_create_by!(badge_type: "engager", level: "silver") do |badge|
    badge.name = "Silver Engager"
    badge.points_required = 200
    badge.description = "Vous êtes un membre très actif"
    badge.reward_type = "premium"
    badge.reward_description = "Accès à des fonctionnalités avancées"
  end
  
  Badge.find_or_create_by!(badge_type: "engager", level: "gold") do |badge|
    badge.name = "Gold Engager"
    badge.points_required = 500
    badge.description = "Vous êtes un pilier de la communauté"
    badge.reward_type = "premium"
    badge.reward_description = "Accès à des fonctionnalités exclusives"
  end
  
  # Création des utilisateurs de test si nécessaire
  unless User.exists?(email: "theo@example.com")
    theo = User.create!(
      email: "theo@example.com",
      password: "123456",
      password_confirmation: "123456"
    )
    
    # Attribuer quelques badges à Théo
    bronze_competitor = Badge.find_by(name: "Bronze Competitor")
    if bronze_competitor
      UserBadge.create!(
        user: theo,
        badge: bronze_competitor,
        earned_at: 2.days.ago,
        points_at_earned: 120
      )
    end
    
    bronze_engager = Badge.find_by(name: "Bronze Engager")
    if bronze_engager
      UserBadge.create!(
        user: theo,
        badge: bronze_engager,
        earned_at: 5.days.ago,
        points_at_earned: 55
      )
    end
  end
