namespace :validate do
  desc "Valider l'intégrité des données (scores, jeux, swipes)"
  task data_integrity: :environment do
    puts "=== VALIDATION DE L'INTÉGRITÉ DES DONNÉES ==="
    
    # 1. Vérifier les scores orphelins (sans jeux)
    orphaned_scores = Score.joins(:playlist)
                          .left_joins(:user => :games)
                          .where(games: { id: nil })
    
    if orphaned_scores.any?
      puts "❌ PROBLÈME: #{orphaned_scores.count} scores orphelins trouvés:"
      orphaned_scores.includes(:user, :playlist).each do |score|
        puts "  - #{score.user.email}: #{score.points} points pour '#{score.playlist.title}'"
      end
    else
      puts "✅ Aucun score orphelin trouvé"
    end
    
    # 2. Vérifier les swipes orphelins (sans jeux)
    orphaned_swipes = Swipe.joins(:playlist)
                          .left_joins(:user => :games)
                          .where(games: { id: nil })
    
    if orphaned_swipes.any?
      puts "❌ PROBLÈME: #{orphaned_swipes.count} swipes orphelins trouvés"
    else
      puts "✅ Aucun swipe orphelin trouvé"
    end
    
    # 3. Vérifier la cohérence des données par utilisateur
    puts "\n=== COHÉRENCE PAR UTILISATEUR ==="
    User.all.each do |user|
      scores_count = user.scores.count
      games_count = user.games.count
      swipes_count = user.swipes.count
      
      if scores_count > 0 && games_count == 0
        puts "❌ #{user.email}: #{scores_count} scores mais 0 jeux"
      elsif swipes_count > 0 && games_count == 0
        puts "❌ #{user.email}: #{swipes_count} swipes mais 0 jeux"
      else
        puts "✅ #{user.email}: #{games_count} jeux, #{scores_count} scores, #{swipes_count} swipes"
      end
    end
    
    # 4. Vérifier les playlists Challenge Reward
    challenge_playlists = Playlist.where("title LIKE ?", "%Challenge Reward%")
    puts "\n=== VÉRIFICATION DES PLAYLISTS CHALLENGE REWARD ==="
    
    challenge_playlists.each do |playlist|
      if playlist.points_required != 9999
        puts "❌ Playlist '#{playlist.title}' n'a pas points_required=9999 (actuel: #{playlist.points_required})"
      elsif !playlist.hidden?
        puts "❌ Playlist '#{playlist.title}' n'est pas cachée"
      else
        puts "✅ Playlist '#{playlist.title}' correctement configurée"
      end
    end
    
    puts "\n=== VALIDATION TERMINÉE ==="
  end
  
  desc "Nettoyer les scores orphelins"
  task clean_orphaned_scores: :environment do
    puts "=== NETTOYAGE DES SCORES ORPHELINS ==="
    
    orphaned_scores = Score.joins(:playlist)
                          .left_joins(:user => :games)
                          .where(games: { id: nil })
    
    if orphaned_scores.any?
      puts "Suppression de #{orphaned_scores.count} scores orphelins..."
      orphaned_scores.destroy_all
      puts "✅ Scores orphelins supprimés"
    else
      puts "✅ Aucun score orphelin à supprimer"
    end
  end
end
