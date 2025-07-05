# Script pour configurer les utilisateurs selon les spécifications
# À exécuter dans Rails console

puts "Configuration des utilisateurs..."

# 1. USER - Top Engager (44 points d'engagement)
user = User.find_by(email: 'user@example.com') || User.find_by(email: 'user')
if user
  puts "Configuration de #{user.email}..."
  
  # Supprimer tous les swipes existants
  user.swipes.destroy_all
  
  # Créer 44 swipes pour avoir 44 points d'engagement
  # Utiliser plusieurs vidéos pour éviter les doublons
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
    puts "✓ #{user.email} : 44 points d'engagement créés"
  else
    puts "✗ Erreur : Pas assez de vidéos ou de jeux pour #{user.email}"
  end
else
  puts "✗ Utilisateur 'user' non trouvé"
end

# 2. DRISS - Top Ratio (10% de ratio)
driss = User.find_by(email: 'driss@example.com')
if driss
  puts "Configuration de #{driss.email}..."
  
  # Supprimer tous les swipes existants
  driss.swipes.destroy_all
  
  # Pour avoir 10% de ratio, on veut 10% de likes et 90% de dislikes
  # Créons 100 swipes au total pour avoir des statistiques précises
  videos = Video.limit(100)
  games = Game.where(user: driss).limit(10)
  
  if videos.any? && games.any?
    # 10 likes (10%)
    10.times do |i|
      video = videos[i]
      game = games[i % games.count]
      
      Swipe.create!(
        user: driss,
        video: video,
        game: game,
        action: 'like',
        liked: true,
        playlist: video.playlist
      )
    end
    
    # 90 dislikes (90%)
    90.times do |i|
      video = videos[i + 10]
      game = games[(i + 10) % games.count]
      
      Swipe.create!(
        user: driss,
        video: video,
        game: game,
        action: 'dislike',
        liked: false,
        playlist: video.playlist
      )
    end
    
    puts "✓ #{driss.email} : 10% de ratio créé (10 likes, 90 dislikes)"
  else
    puts "✗ Erreur : Pas assez de vidéos ou de jeux pour #{driss.email}"
  end
else
  puts "✗ Utilisateur 'driss@example.com' non trouvé"
end

# 3. THÉO - Top Critic (15 points de critique)
theo = User.find_by(email: 'theo@example.com')
if theo
  puts "Configuration de #{theo.email}..."
  
  # Supprimer tous les swipes existants
  theo.swipes.destroy_all
  
  # Pour avoir 15 points de critique, on veut un gap de 0-20%
  # Créons 100 swipes avec un ratio équilibré (50/50 ou proche)
  videos = Video.limit(100)
  games = Game.where(user: theo).limit(10)
  
  if videos.any? && games.any?
    # 55 likes (55%)
    55.times do |i|
      video = videos[i]
      game = games[i % games.count]
      
      Swipe.create!(
        user: theo,
        video: video,
        game: game,
        action: 'like',
        liked: true,
        playlist: video.playlist
      )
    end
    
    # 45 dislikes (45%)
    45.times do |i|
      video = videos[i + 55]
      game = games[(i + 55) % games.count]
      
      Swipe.create!(
        user: theo,
        video: video,
        game: game,
        action: 'dislike',
        liked: false,
        playlist: video.playlist
      )
    end
    
    puts "✓ #{theo.email} : 15 points de critique créés (55 likes, 45 dislikes - gap de 10%)"
  else
    puts "✗ Erreur : Pas assez de vidéos ou de jeux pour #{theo.email}"
  end
else
  puts "✗ Utilisateur 'theo@example.com' non trouvé"
end

puts "\nConfiguration terminée !"
puts "\nRésumé :"
puts "- User : 44 points d'engagement (Top engager du jour)"
puts "- Driss : 10% de ratio (Top Ratio du jour)" 
puts "- Théo : 15 points de critique (Top critic du jour)" 