namespace :fix_gameplay_logic do
  desc "Fix all gameplay logic issues: remove challenge reward scores, fix leaderboards, clean invalid data"
  task all: :environment do
    puts "🔧 CORRECTION DE LA LOGIQUE DE GAMEPLAY"
    puts "=" * 60
    
    # 1. Supprimer tous les scores des playlists Challenge Reward
    puts "\n1. 🗑️  Suppression des scores Challenge Reward..."
    challenge_playlists = Playlist.where("LOWER(title) LIKE ?", "%challenge reward%")
    challenge_playlist_ids = challenge_playlists.pluck(:id)
    
    deleted_scores = Score.where(playlist_id: challenge_playlist_ids).count
    Score.where(playlist_id: challenge_playlist_ids).delete_all
    puts "   ✅ #{deleted_scores} scores supprimés des playlists Challenge Reward"
    
    # 2. Supprimer les swipes associés aux playlists Challenge Reward (avant les jeux)
    puts "\n2. 👆 Suppression des swipes Challenge Reward..."
    deleted_swipes = Swipe.where(playlist_id: challenge_playlist_ids).count
    Swipe.where(playlist_id: challenge_playlist_ids).delete_all
    puts "   ✅ #{deleted_swipes} swipes supprimés des playlists Challenge Reward"
    
    # 3. Supprimer les jeux associés aux playlists Challenge Reward
    puts "\n3. 🎮 Suppression des jeux Challenge Reward..."
    deleted_games = Game.where(playlist_id: challenge_playlist_ids).count
    Game.where(playlist_id: challenge_playlist_ids).delete_all
    puts "   ✅ #{deleted_games} jeux supprimés des playlists Challenge Reward"
    
    # 4. Vérifier et corriger les playlists Challenge Reward
    puts "\n4. 🔒 Vérification des playlists Challenge Reward..."
    challenge_playlists.each do |playlist|
      if playlist.points_required.nil? || playlist.points_required < 9999
        playlist.update!(points_required: 9999, hidden: true, exclusive: true)
        puts "   ✅ #{playlist.title}: points_required=9999, hidden=true"
      end
    end
    
    # 5. Nettoyer les récompenses invalides
    puts "\n5. 🎁 Nettoyage des récompenses invalides..."
    invalid_rewards = Reward.where(content_type: ['challenge_reward_playlist_1', 'challenge_reward_playlist_2', 'challenge_reward_playlist_3', 'challenge_reward_playlist_4', 'challenge_reward_playlist_5', 'challenge_reward_playlist_6', 'challenge_reward_playlist_7', 'challenge_reward_playlist_8', 'challenge_reward_playlist_9', 'challenge_reward_playlist_10', 'challenge_reward_playlist_11', 'challenge_reward_playlist_12', 'challenge_reward_playlist_13', 'challenge_reward_playlist_14', 'challenge_reward_playlist_15'])
    deleted_rewards = invalid_rewards.count
    invalid_rewards.delete_all
    puts "   ✅ #{deleted_rewards} récompenses Challenge Reward supprimées"
    
    # 6. Vérifier les utilisateurs sans activité réelle
    puts "\n6. 👥 Vérification des utilisateurs..."
    User.all.each do |user|
      games_count = user.games.count
      scores_count = user.scores.count
      swipes_count = user.swipes.count
      
      if games_count == 0 && scores_count == 0 && swipes_count == 0
        puts "   ℹ️  #{user.email}: Aucune activité de jeu"
      else
        puts "   ✅ #{user.email}: #{games_count} jeux, #{scores_count} scores, #{swipes_count} swipes"
      end
    end
    
    puts "\n✅ CORRECTION TERMINÉE"
    puts "=" * 60
    puts "La logique de gameplay est maintenant cohérente !"
    puts "- Les playlists Challenge Reward sont correctement verrouillées"
    puts "- Les scores invalides ont été supprimés"
    puts "- Les classements reflètent uniquement l'activité légitime"
  end
end
