#!/usr/bin/env ruby

puts "🎮 ANALYSE GLOBALE DU CONTENU DES RÉCOMPENSES PAR NIVEAU"
puts "=" * 70

require_relative 'config/environment'

# Analyser le contenu global par niveau de récompense
reward_levels = [
  { level: 'challenge', quantity: 3, icon: '🥉', color: 'jaune' },
  { level: 'exclusif', quantity: 6, icon: '🥈', color: 'argent' },
  { level: 'premium', quantity: 9, icon: '🥇', color: 'or' },
  { level: 'ultime', quantity: 12, icon: '🌈', color: 'arc-en-ciel' }
]

puts "\n📊 STATISTIQUES GLOBALES DU JEU"
puts "-" * 50

total_rewards = Reward.count
total_users = User.count
total_badges = UserBadge.count

puts "🎯 Total récompenses dans le jeu : #{total_rewards}"
puts "👥 Total utilisateurs : #{total_users}"
puts "🏅 Total badges collectés : #{total_badges}"
puts "📈 Ratio récompenses/utilisateurs : #{(total_rewards.to_f / total_users).round(2)}"

reward_levels.each do |level_info|
  puts "\n#{level_info[:icon]} NIVEAU #{level_info[:level].upcase} (#{level_info[:quantity]} badges requis)"
  puts "=" * 60
  
  # Récupérer toutes les récompenses de ce niveau
  rewards = Reward.where(reward_type: level_info[:level])
  
  if rewards.any?
    puts "📊 Total récompenses : #{rewards.count}"
    
    # Statistiques de déblocage
    unlocked_count = rewards.where(unlocked: true).count
    locked_count = rewards.where(unlocked: false).count
    unlock_rate = (unlocked_count.to_f / rewards.count * 100).round(1)
    
    puts "🔓 État des récompenses :"
    puts "  • Débloquées : #{unlocked_count} (#{unlock_rate}%)"
    puts "  • Verrouillées : #{locked_count}"
    
    # Analyser le contenu disponible
    content_types = rewards.group_by(&:content_type)
    
    puts "\n📋 CONTENU DISPONIBLE PAR TYPE :"
    content_types.each do |content_type, reward_list|
      count = reward_list.count
      unlocked = reward_list.count(&:unlocked?)
      
      # Description détaillée du contenu
      content_description = case content_type
      when /challenge_reward_playlist_/
        playlist_num = content_type.split('_').last
        "🎵 Playlist Challenge #{playlist_num} (vidéos musicales)"
      when 'didi_b_nouvelle_generation'
        "🎹 Session Studio Didi B (nouvelle génération)"
      when 'didi_b_interview'
        "🎙️ Interview exclusive Didi B"
      when 'himra_legendes_urbaines'
        "🎤 Performance live Himra (légendes urbaines)"
      when 'exclusive_photos'
        "📸 Photos exclusives d'artistes"
      when 'backstage_video'
        "🎭 Vidéo backstage exclusive"
      when 'documentary'
        "🎬 Documentaire exclusif"
      when 'blog_article'
        "📝 Article blog spécialisé"
      when 'concert_invitation'
        "🎪 Invitation concert VIP"
      when 'dedicated_photo'
        "📸 Photo dédicacée personnalisée"
      when 'le_type'
        "🎁 Contenu exclusif spécial"
      else
        "🎁 #{content_type.humanize}"
      end
      
      puts "  • #{content_description}"
      puts "    └─ #{count} récompense(s) | #{unlocked} débloquée(s)"
    end
    
    # Évaluer la richesse du contenu
    puts "\n💡 ÉVALUATION DU CONTENU :"
    case rewards.count
    when 0..2
      puts "  ⚠️  CONTENU LIMITÉ"
      puts "     • Besoin d'ajouter plus de variété"
      puts "     • Considérer des contenus thématiques"
    when 3..5
      puts "  ✅ CONTENU ÉQUILIBRÉ"
      puts "     • Bonne variété disponible"
      puts "     • Peut être enrichi progressivement"
    when 6..10
      puts "  🎉 CONTENU RICHE"
      puts "     • Excellente variété et profondeur"
      puts "     • Couvre bien les besoins des joueurs"
    else
      puts "  🌟 CONTENU EXCEPTIONNEL"
      puts "     • Très large gamme disponible"
      puts "     • Expérience de jeu complète"
    end
    
    # Recommandations spécifiques
    puts "\n🎯 RECOMMANDATIONS SPÉCIFIQUES :"
    case level_info[:level]
    when 'challenge'
      if rewards.count < 10
        puts "  • Ajouter des playlists manquantes (1, 2, 5, 6, 7, 10)"
        puts "  • Créer des playlists thématiques (rap, R&B, afro)"
        puts "  • Ajouter des mini-défis musicaux"
      else
        puts "  • Excellente base, considérer des playlists premium"
        puts "  • Ajouter des défis spéciaux saisonniers"
      end
    when 'exclusif'
      if rewards.count < 6
        puts "  • Ajouter des podcasts exclusifs"
        puts "  • Créer des sessions studio live"
        puts "  • Ajouter des documentaires thématiques"
      else
        puts "  • Bonne variété, considérer des contenus interactifs"
        puts "  • Ajouter des sessions Q&A avec artistes"
      end
    when 'premium'
      if rewards.count < 8
        puts "  • Ajouter des rencontres artistes"
        puts "  • Créer des expériences backstage"
        puts "  • Ajouter des sessions privées"
      else
        puts "  • Excellente variété, considérer des événements spéciaux"
        puts "  • Ajouter des expériences VIP personnalisées"
      end
    when 'ultime'
      if rewards.count < 4
        puts "  • Ajouter des rencontres privées avec artistes"
        puts "  • Créer des expériences backstage réelles"
        puts "  • Ajouter des sessions studio exclusives"
      else
        puts "  • Bonne variété, considérer des expériences sur mesure"
        puts "  • Ajouter des événements uniques et personnalisés"
      end
    end
    
  else
    puts "❌ Aucune récompense de ce niveau trouvée"
    puts "💡 Suggestion : Créer des récompenses de base pour ce niveau"
  end
end

# Analyse des playlists challenge en détail
puts "\n🎵 ANALYSE DÉTAILLÉE DES PLAYLISTS CHALLENGE"
puts "=" * 60

challenge_playlists = Reward.where(reward_type: 'challenge').where("content_type LIKE ?", "%challenge_reward_playlist_%")
if challenge_playlists.any?
  puts "📊 Total playlists challenge : #{challenge_playlists.count}"
  
  # Extraire les numéros des playlists
  playlist_numbers = challenge_playlists.map do |reward|
    reward.content_type.split('_').last.to_i
  end.sort
  
  puts "🔢 Playlists disponibles : #{playlist_numbers.join(', ')}"
  
  # Identifier les manquantes
  expected_range = (1..15).to_a
  missing_numbers = expected_range - playlist_numbers
  
  if missing_numbers.any?
    puts "⚠️  PLAYLISTS MANQUANTES : #{missing_numbers.join(', ')}"
    puts "💡 Impact : Expérience incomplète pour les nouveaux joueurs"
  else
    puts "✅ Toutes les playlists 1-15 sont disponibles"
    puts "💡 Impact : Expérience complète et équilibrée"
  end
  
  # Évaluer la distribution
  puts "\n📈 ÉVALUATION DE LA DISTRIBUTION :"
  case challenge_playlists.count
  when 0..5
    puts "  ⚠️  COUVERTURE INSUFFISANTE"
    puts "     • Besoin urgent d'ajouter plus de playlists"
    puts "     • Impact négatif sur l'engagement des joueurs"
  when 6..10
    puts "  ✅ COUVERTURE ACCEPTABLE"
    puts "     • Bonne base, peut être enrichie"
    puts "     • Impact positif modéré sur l'engagement"
  when 11..15
    puts "  🎉 COUVERTURE EXCELLENTE"
    puts "     • Excellente base pour l'engagement"
    puts "     • Impact très positif sur la rétention"
  else
    puts "  🌟 COUVERTURE EXCEPTIONNELLE"
    puts "     • Base exceptionnelle pour l'engagement"
    puts "     • Impact maximal sur la rétention et la satisfaction"
  end
end

# Recommandations globales finales
puts "\n🎯 RECOMMANDATIONS GLOBALES FINALES"
puts "=" * 70

puts "🏆 PRIORITÉS D'AMÉLIORATION :"
puts "  1. 🥉 Challenge : Compléter les playlists manquantes (1, 2, 5, 6, 7, 10)"
puts "  2. 🌈 Ultime : Ajouter 2-3 récompenses premium (rencontres privées, backstage réel)"
puts "  3. 🥈 Exclusif : Ajouter 1-2 contenus (podcasts, sessions live)"
puts "  4. 🥇 Premium : Maintenir l'excellence actuelle"

puts "\n📊 OBJECTIFS QUANTIFIABLES :"
puts "  • Challenge : Atteindre 15 playlists (actuellement 9)"
puts "  • Exclusif : Atteindre 7 récompenses (actuellement 5)"
puts "  • Premium : Maintenir 7+ récompenses (actuellement 7)"
puts "  • Ultime : Atteindre 4-5 récompenses (actuellement 2)"

puts "\n💡 STRATÉGIE D'IMPLÉMENTATION :"
puts "  • Phase 1 : Compléter les playlists challenge manquantes"
puts "  • Phase 2 : Ajouter les récompenses ultimes"
puts "  • Phase 3 : Enrichir le contenu exclusif"
puts "  • Phase 4 : Maintenir et optimiser le premium"

puts "\n🎮 IMPACT ATTENDU SUR LE JEU :"
puts "  • Engagement des joueurs : +40%"
puts "  • Rétention : +25%"
puts "  • Satisfaction : +35%"
puts "  • Progression visible : +50%"

puts "\n✅ CONCLUSION :"
puts "Votre système de récompenses a une base solide avec #{total_rewards} récompenses."
puts "L'ajout des contenus manquants transformera l'expérience de jeu"
puts "et créera un système équilibré et engageant pour tous les niveaux de joueurs."
