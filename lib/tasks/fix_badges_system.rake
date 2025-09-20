namespace :badges do
  desc "Fix badges earned with old point system"
  task fix_old_badges: :environment do
    puts "🔧 CORRECTION DES BADGES OBTENUS AVEC L'ANCIEN SYSTÈME"
    puts "=" * 60
    
    User.all.each do |user|
      puts "\n👤 #{user.email}:"
      puts "   Points achetés: #{user.purchased_points}"
      puts "   Points de jeu: #{user.game_points}"
      puts "   Total points: #{user.total_points}"
      
      # Vérifier les badges obtenus avec l'ancien système
      old_badges = user.user_badges.where('points_at_earned > ?', user.total_points)
      
      if old_badges.any?
        puts "   🚨 #{old_badges.count} badges obtenus avec l'ancien système:"
        old_badges.each do |user_badge|
          badge = user_badge.badge
          puts "     - #{badge.name} (#{badge.level} #{badge.badge_type})"
          puts "       Points requis: #{badge.points_required}"
          puts "       Points lors de l'obtention: #{user_badge.points_at_earned}"
          puts "       Points actuels: #{user.total_points}"
        end
        
        # Option 1: Supprimer les badges obtenus avec l'ancien système
        puts "   🔄 Suppression des badges obtenus avec l'ancien système..."
        old_badges.destroy_all
        puts "   ✅ Badges supprimés"
        
        # Option 2: Recalculer les badges avec le nouveau système
        puts "   🔄 Recalcul des badges avec le nouveau système..."
        BadgeService.assign_badges(user)
        puts "   ✅ Badges recalculés"
      else
        puts "   ✅ Aucun badge obtenu avec l'ancien système"
      end
      
      # Afficher les badges actuels
      current_badges = user.user_badges.includes(:badge)
      puts "   🏅 Badges actuels (#{current_badges.count}):"
      current_badges.each do |user_badge|
        badge = user_badge.badge
        puts "     - #{badge.name} (#{badge.level} #{badge.badge_type}) - Points requis: #{badge.points_required}"
      end
    end
    
    puts "\n✅ CORRECTION TERMINÉE"
    puts "=" * 60
  end
  
  desc "Test the corrected badge system"
  task test_system: :environment do
    puts "🧪 TEST DU SYSTÈME DE BADGES CORRIGÉ"
    puts "=" * 50
    
    User.all.each do |user|
      puts "\n👤 #{user.email}:"
      puts "   Points achetés: #{user.purchased_points}"
      puts "   Points de jeu: #{user.game_points}"
      puts "   Total points: #{user.total_points}"
      puts "   Badges: #{user.user_badges.count}"
      
      # Vérifier la cohérence des badges
      user.user_badges.includes(:badge).each do |user_badge|
        badge = user_badge.badge
        if user.total_points >= badge.points_required
          puts "   ✅ #{badge.name}: Cohérent (#{user.total_points} >= #{badge.points_required})"
        else
          puts "   ❌ #{badge.name}: Incohérent (#{user.total_points} < #{badge.points_required})"
        end
      end
    end
  end
end
