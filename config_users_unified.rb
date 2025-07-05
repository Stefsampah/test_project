# Script pour configurer les utilisateurs avec la logique unifiée des badges
# À exécuter dans Rails console

puts "Configuration des utilisateurs avec logique unifiée..."

# 1. USER - Top Engager (meilleur engager_score)
user = User.find_by(email: 'user@example.com') || User.find_by(email: 'user')
if user
  puts "Configuration de #{user.email}..."
  
  # Supprimer tous les swipes et scores existants
  user.swipes.destroy_all
  user.scores.destroy_all
  
  # Créer des swipes pour avoir un bon engager_score (swipes.count * 10)
  # Pour avoir 440 points d'engagement, il faut 44 swipes
  videos = Video.limit(50)
  games = Game.where(user: user).limit(5)
  
  if videos.any? && games.any?
    44.times do |i|
      video = videos[i % videos.count]
      game = games[i % games.count]
      
      Swipe.create!(
        user: user,
        video: video,
        game: game,
        action: ['like', 'dislike'].sample,
        liked: [true, false].sample,
        playlist: video.playlist
      )
    end
    
    # Créer quelques scores pour competitor_score
    playlists = Playlist.limit(3)
    playlists.each do |playlist|
      Score.create!(
        user: user,
        playlist: playlist,
        points: rand(100..300)
      )
    end
    
    puts "✓ #{user.email} : 440 points d'engagement (44 swipes), scores de compétition créés"
  else
    puts "✗ Erreur : Pas assez de vidéos ou de jeux pour #{user.email}"
  end
else
  puts "✗ Utilisateur 'user' non trouvé"
end

# 2. DRISS - Top Ratio (meilleur competitor_score)
driss = User.find_by(email: 'driss@example.com')
if driss
  puts "Configuration de #{driss.email}..."
  
  # Supprimer tous les swipes et scores existants
  driss.swipes.destroy_all
  driss.scores.destroy_all
  
  # Créer des scores élevés pour avoir le meilleur competitor_score
  playlists = Playlist.limit(5)
  playlists.each do |playlist|
    Score.create!(
      user: driss,
      playlist: playlist,
      points: rand(800..1200)
    )
  end
  
  # Créer quelques swipes pour engager_score
  videos = Video.limit(20)
  games = Game.where(user: driss).limit(3)
  
  if videos.any? && games.any?
    20.times do |i|
      video = videos[i]
      game = games[i % games.count]
      
      Swipe.create!(
        user: driss,
        video: video,
        game: game,
        action: ['like', 'dislike'].sample,
        liked: [true, false].sample,
        playlist: video.playlist
      )
    end
    puts "✓ #{driss.email} : Scores de compétition élevés, 200 points d'engagement (20 swipes)"
  else
    puts "✗ Erreur : Pas assez de vidéos ou de jeux pour #{driss.email}"
  end
else
  puts "✗ Utilisateur 'driss@example.com' non trouvé"
end

# 3. THÉO - Top Critic (meilleur critic_score)
theo = User.find_by(email: 'theo@example.com')
if theo
  puts "Configuration de #{theo.email}..."
  
  # Supprimer tous les swipes et scores existants
  theo.swipes.destroy_all
  theo.scores.destroy_all
  
  # Créer beaucoup de dislikes pour avoir le meilleur critic_score (dislikes.count * 5)
  # Pour avoir 150 points de critique, il faut 30 dislikes
  videos = Video.limit(50)
  games = Game.where(user: theo).limit(5)
  
  if videos.any? && games.any?
    # 30 dislikes pour critic_score
    30.times do |i|
      video = videos[i]
      game = games[i % games.count]
      
      Swipe.create!(
        user: theo,
        video: video,
        game: game,
        action: 'dislike',
        liked: false,
        playlist: video.playlist
      )
    end
    
    # Quelques likes pour engager_score
    10.times do |i|
      video = videos[i + 30]
      game = games[(i + 30) % games.count]
      
      Swipe.create!(
        user: theo,
        video: video,
        game: game,
        action: 'like',
        liked: true,
        playlist: video.playlist
      )
    end
    
    # Créer quelques scores pour competitor_score
    playlists = Playlist.limit(2)
    playlists.each do |playlist|
      Score.create!(
        user: theo,
        playlist: playlist,
        points: rand(200..400)
      )
    end
    
    puts "✓ #{theo.email} : 150 points de critique (30 dislikes), 400 points d'engagement (40 swipes)"
  else
    puts "✗ Erreur : Pas assez de vidéos ou de jeux pour #{theo.email}"
  end
else
  puts "✗ Utilisateur 'theo@example.com' non trouvé"
end

puts "\nConfiguration terminée !"
puts "\nRésumé avec logique unifiée :"
puts "- User : Meilleur engager_score (440 pts) → Badge 'Top engager du jour'"
puts "- Driss : Meilleur competitor_score → Badge 'Top Ratio du jour'" 
puts "- Théo : Meilleur critic_score (150 pts) → Badge 'Top Critic du jour'"
puts "\nLes deux systèmes utilisent maintenant la même logique de calcul !" 