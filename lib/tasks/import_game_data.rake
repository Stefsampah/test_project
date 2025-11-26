namespace :data do
  desc "Import game data from local JSON files to Heroku"
  task import_to_heroku: :environment do
    puts "📥 Import des données de jeu vers Heroku..."
    
    # Charger les données exportées
    games_data = JSON.parse(File.read('tmp/games_export.json'))
    swipes_data = JSON.parse(File.read('tmp/swipes_export.json'))
    scores_data = JSON.parse(File.read('tmp/scores_export.json'))
    user_badges_data = JSON.parse(File.read('tmp/user_badges_export.json'))
    unlocks_data = JSON.parse(File.read('tmp/unlocks_export.json'))
    users_data = JSON.parse(File.read('tmp/users_export.json'))
    
    # Créer un mapping des utilisateurs locaux vers Heroku par email
    local_user_ids = {}
    users_data.each do |user_data|
      local_user = User.find_by(email: user_data['email'])
      if local_user
        local_user_ids[local_user.id] = user_data['email']
      end
    end
    
    # Mapping des utilisateurs par email
    user_mapping = {}
    users_data.each do |user_data|
      user = User.find_by(email: user_data['email'])
      if user
        # Mettre à jour les points et VIP
        user.update!(
          points: user_data['points'] || 0,
          vip_subscription: user_data['vip_subscription'] || false,
          vip_expires_at: user_data['vip_expires_at'] ? Time.parse(user_data['vip_expires_at']) : nil,
          admin: user_data['admin'] || false
        )
        user_mapping[user_data['email']] = user.id
        puts "✅ Utilisateur #{user_data['email']} mis à jour (points: #{user.points || 0}, VIP: #{user.vip_subscription})"
      end
    end
    
    # Créer un mapping des playlists locales vers Heroku par titre
    # On va devoir charger les playlists locales depuis un fichier ou utiliser l'ordre
    # Pour simplifier, on va utiliser l'ordre des playlists créées dans les seeds
    playlist_mapping = {}
    Playlist.order(:id).each_with_index do |playlist, index|
      playlist_mapping[index + 1] = playlist.id
    end
    
    # Import des games
    games_imported = 0
    games_skipped = 0
    games_data.each do |game_data|
      # Trouver l'email de l'utilisateur local
      local_user_email = local_user_ids[game_data['user_id']]
      next unless local_user_email
      
      heroku_user = User.find_by(email: local_user_email)
      next unless heroku_user
      
      # Utiliser le mapping des playlists (approximatif - basé sur l'ordre)
      heroku_playlist_id = playlist_mapping[game_data['playlist_id']] || game_data['playlist_id']
      heroku_playlist = Playlist.find_by(id: heroku_playlist_id)
      unless heroku_playlist
        games_skipped += 1
        next
      end
      
      Game.find_or_create_by!(
        user_id: heroku_user.id,
        playlist_id: heroku_playlist.id
      ) do |g|
        g.completed_at = game_data['completed_at'] ? Time.parse(game_data['completed_at']) : nil
        g.created_at = Time.parse(game_data['created_at'])
        g.updated_at = Time.parse(game_data['updated_at'])
      end
      games_imported += 1
    end
    puts "✅ #{games_imported} parties importées (#{games_skipped} ignorées)"
    
    # Import des scores
    scores_imported = 0
    scores_skipped = 0
    scores_data.each do |score_data|
      local_user_email = local_user_ids[score_data['user_id']]
      next unless local_user_email
      
      heroku_user = User.find_by(email: local_user_email)
      next unless heroku_user
      
      heroku_playlist_id = playlist_mapping[score_data['playlist_id']] || score_data['playlist_id']
      heroku_playlist = Playlist.find_by(id: heroku_playlist_id)
      unless heroku_playlist
        scores_skipped += 1
        next
      end
      
      Score.find_or_create_by!(
        user_id: heroku_user.id,
        playlist_id: heroku_playlist.id
      ) do |s|
        s.points = score_data['points']
        s.created_at = Time.parse(score_data['created_at'])
        s.updated_at = Time.parse(score_data['updated_at'])
      end
      scores_imported += 1
    end
    puts "✅ #{scores_imported} scores importés (#{scores_skipped} ignorés)"
    
    # Import des user_badges
    badges_imported = 0
    badges_skipped = 0
    user_badges_data.each do |ub_data|
      local_user_email = local_user_ids[ub_data['user_id']]
      next unless local_user_email
      
      heroku_user = User.find_by(email: local_user_email)
      next unless heroku_user
      
      # Le badge_id devrait être le même (les badges sont créés dans le même ordre)
      heroku_badge = Badge.find_by(id: ub_data['badge_id'])
      unless heroku_badge
        badges_skipped += 1
        next
      end
      
      UserBadge.find_or_create_by!(
        user_id: heroku_user.id,
        badge_id: heroku_badge.id
      ) do |ub|
        ub.earned_at = ub_data['earned_at'] ? Time.parse(ub_data['earned_at']) : nil
        ub.points_at_earned = ub_data['points_at_earned']
        ub.claimed_at = ub_data['claimed_at'] ? Time.parse(ub_data['claimed_at']) : nil
        ub.created_at = Time.parse(ub_data['created_at'])
        ub.updated_at = Time.parse(ub_data['updated_at'])
      end
      badges_imported += 1
    end
    puts "✅ #{badges_imported} badges utilisateurs importés (#{badges_skipped} ignorés)"
    
    # Import des swipes (plus complexe car nécessite video_id)
    # On va devoir mapper les vidéos par youtube_id
    swipes_imported = 0
    swipes_skipped = 0
    
    # Créer un mapping des vidéos locales vers Heroku par youtube_id
    # On va devoir charger les vidéos locales depuis un fichier
    # Pour l'instant, on va essayer de trouver les vidéos directement
    swipes_data.each do |swipe_data|
      local_user_email = local_user_ids[swipe_data['user_id']]
      next unless local_user_email
      
      heroku_user = User.find_by(email: local_user_email)
      next unless heroku_user
      
      # Trouver la vidéo locale (on doit avoir accès à la base locale)
      # Pour l'instant, on va utiliser l'ID directement et espérer que les IDs correspondent
      heroku_video = Video.find_by(id: swipe_data['video_id'])
      unless heroku_video
        swipes_skipped += 1
        next
      end
      
      heroku_playlist_id = playlist_mapping[swipe_data['playlist_id']] || swipe_data['playlist_id']
      heroku_playlist = Playlist.find_by(id: heroku_playlist_id)
      unless heroku_playlist
        swipes_skipped += 1
        next
      end
      
      heroku_game = Game.find_by(user_id: heroku_user.id, playlist_id: heroku_playlist.id)
      unless heroku_game
        swipes_skipped += 1
        next
      end
      
      Swipe.find_or_create_by!(
        user_id: heroku_user.id,
        video_id: heroku_video.id,
        game_id: heroku_game.id
      ) do |s|
        s.liked = swipe_data['liked']
        s.action = swipe_data['action']
        s.playlist_id = heroku_playlist.id
        s.created_at = Time.parse(swipe_data['created_at'])
        s.updated_at = Time.parse(swipe_data['updated_at'])
      end
      swipes_imported += 1
    end
    puts "✅ #{swipes_imported} swipes importés (#{swipes_skipped} ignorés)"
    
    puts "🎉 Import terminé !"
    puts "\n📊 Résumé:"
    puts "  - Utilisateurs mis à jour: #{user_mapping.count}"
    puts "  - Parties: #{games_imported}"
    puts "  - Scores: #{scores_imported}"
    puts "  - Badges: #{badges_imported}"
    puts "  - Swipes: #{swipes_imported}"
  end
end
