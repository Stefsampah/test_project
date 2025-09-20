namespace :fix_badges do
  desc "Remove badges earned with purchased points and reassign based on game points only"
  task game_points_only: :environment do
    puts "🔧 CORRECTION DES BADGES - POINTS DE JEU UNIQUEMENT"
    puts "=" * 60
    
    User.all.each do |user|
      puts "\n👤 Utilisateur: #{user.email}"
      puts "   Points totaux: #{user.total_points} (achetés: #{user.purchased_points} + jeu: #{user.game_points})"
      
      # Supprimer tous les badges existants
      old_badges_count = user.user_badges.count
      user.user_badges.destroy_all
      puts "   🗑️  #{old_badges_count} badges supprimés"
      
      # Réattribuer les badges basés uniquement sur les points de jeu
      BadgeService.assign_badges(user)
      new_badges_count = user.user_badges.count
      puts "   ✅ #{new_badges_count} badges réattribués (basés sur #{user.game_points} points de jeu)"
      
      if new_badges_count > 0
        user.user_badges.includes(:badge).each do |user_badge|
          badge = user_badge.badge
          puts "     🏅 #{badge.name} (#{badge.points_required} points requis)"
        end
      end
    end
    
    puts "\n✅ CORRECTION TERMINÉE"
    puts "=" * 60
    puts "Les badges sont maintenant basés uniquement sur les points de jeu !"
  end
end
