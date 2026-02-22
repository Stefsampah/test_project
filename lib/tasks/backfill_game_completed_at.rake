# Backfill completed_at pour les parties déjà terminées (toutes les vidéos swipées)
# mais qui n'avaient pas completed_at renseigné (bug corrigé dans SwipesController).
# À lancer une fois sur Heroku : heroku run rails backfill_game_completed_at:run --app tubenplay-app
namespace :backfill_game_completed_at do
  desc "Met à jour completed_at pour les games terminées (sans completed_at)"
  task run: :environment do
    games = Game.where(completed_at: nil)
    updated = 0
    games.find_each do |game|
      next unless game.completed?
      game.update_column(:completed_at, game.updated_at)
      updated += 1
      puts "  Game ##{game.id} (playlist #{game.playlist_id}, user #{game.user_id}) -> completed_at mis à jour"
    end
    puts "✅ #{updated} partie(s) mises à jour sur #{games.count} sans completed_at."
  end
end
