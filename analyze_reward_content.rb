#!/usr/bin/env ruby

puts "🎯 ANALYSE DU CONTENU PAR TYPE DE RÉCOMPENSE"
puts "=" * 60

require_relative 'config/environment'

# Analyser chaque type de récompense
reward_types = [
  { type: 'challenge', quantity: 3, icon: '🥉' },
  { type: 'exclusif', quantity: 6, icon: '🥈' },
  { type: 'premium', quantity: 9, icon: '🥇' },
  { type: 'ultime', quantity: 12, icon: '🌈' }
]

reward_types.each do |reward_info|
  puts "\n#{reward_info[:icon]} #{reward_info[:type].upcase} (#{reward_info[:quantity]} badges requis)"
  puts "-" * 50
  
  # Récupérer toutes les récompenses de ce type
  rewards = Reward.where(reward_type: reward_info[:type])
  
  if rewards.any?
    puts "📊 Total : #{rewards.count} récompenses"
    
    # Grouper par content_type
    content_groups = rewards.group_by(&:content_type)
    
    puts "\n📋 Contenu disponible :"
    content_groups.each do |content_type, reward_list|
      count = reward_list.count
      unlocked_count = reward_list.count(&:unlocked?)
      
      # Détails du contenu selon le type
      content_details = case content_type
      when /challenge_reward_playlist_/
        "🎵 Playlist Challenge (#{content_type.split('_').last} vidéos)"
      when 'didi_b_nouvelle_generation'
        "🎹 Session Studio Didi B"
      when 'didi_b_interview'
        "🎙️ Interview Didi B"
      when 'himra_legendes_urbaines'
        "🎤 Live Himra"
      when 'exclusive_photos'
        "📸 Photos exclusives d'artistes"
      when 'backstage_video'
        "🎭 Vidéo backstage"
      when 'documentary'
        "🎬 Documentaire exclusif"
      when 'blog_article'
        "📝 Article blog spécialisé"
      when 'concert_invitation'
        "🎪 Invitation concert VIP"
      when 'dedicated_photo'
        "📸 Photo dédicacée personnalisée"
      else
        "🎁 #{content_type.humanize}"
      end
      
      puts "  • #{content_details}"
      puts "    └─ #{count} récompense(s) | #{unlocked_count} débloquée(s)"
    end
    
    # Évaluer la richesse du contenu
    puts "\n💡 Évaluation :"
    case rewards.count
    when 0..2
      puts "  ⚠️  Contenu limité - Considérer l'ajout de plus de variété"
    when 3..5
      puts "  ✅ Contenu équilibré - Bonne variété disponible"
    when 6..10
      puts "  🎉 Contenu riche - Excellente variété et profondeur"
    else
      puts "  🌟 Contenu exceptionnel - Très large gamme disponible"
    end
    
  else
    puts "❌ Aucune récompense de ce type trouvée"
  end
end

# Analyse globale des playlists challenge
puts "\n🎵 ANALYSE SPÉCIALE DES PLAYLISTS CHALLENGE"
puts "-" * 50

challenge_playlists = Reward.where(reward_type: 'challenge', content_type: /challenge_reward_playlist_/)
if challenge_playlists.any?
  puts "📊 Total playlists challenge : #{challenge_playlists.count}"
  
  # Vérifier la continuité des numéros
  playlist_numbers = challenge_playlists.map do |reward|
    reward.content_type.split('_').last.to_i
  end.sort
  
  puts "🔢 Numéros disponibles : #{playlist_numbers.join(', ')}"
  
  # Identifier les manquants
  expected_range = (1..15).to_a
  missing_numbers = expected_range - playlist_numbers
  
  if missing_numbers.any?
    puts "⚠️  Playlists manquantes : #{missing_numbers.join(', ')}"
  else
    puts "✅ Toutes les playlists 1-15 sont disponibles"
  end
  
  # Évaluer la distribution
  case challenge_playlists.count
  when 0..5
    puts "💡 Suggestion : Ajouter plus de playlists pour varier l'expérience"
  when 6..10
    puts "💡 Suggestion : Bonne base, considérer l'ajout de playlists thématiques"
  when 11..15
    puts "💡 Suggestion : Excellente couverture, peut-être ajouter des playlists spéciales"
  else
    puts "💡 Suggestion : Couverture complète, considérer des playlists premium"
  end
end

# Recommandations globales
puts "\n🎯 RECOMMANDATIONS GLOBALES"
puts "=" * 60

total_rewards = Reward.count
total_content_types = Reward.distinct.pluck(:content_type).count

puts "📊 Statistiques globales :"
puts "  • Total récompenses : #{total_rewards}"
puts "  • Types de contenu : #{total_content_types}"
puts "  • Ratio contenu/récompense : #{(total_content_types.to_f / total_rewards * 100).round(1)}%"

puts "\n💡 Recommandations par type :"

# Challenge
challenge_count = Reward.where(reward_type: 'challenge').count
if challenge_count < 5
  puts "  🥉 Challenge : Ajouter plus de variété (playlists, mini-jeux, défis)"
elsif challenge_count < 10
  puts "  🥉 Challenge : Bonne base, considérer des playlists thématiques"
else
  puts "  🥉 Challenge : Excellente variété, peut-être des défis spéciaux"
end

# Exclusif
exclusif_count = Reward.where(reward_type: 'exclusif').count
if exclusif_count < 3
  puts "  🥈 Exclusif : Besoin de plus de contenu exclusif (interviews, sessions studio)"
elsif exclusif_count < 6
  puts "  🥈 Exclusif : Bonne variété, considérer des podcasts ou documentaires"
else
  puts "  🥈 Exclusif : Excellente gamme, peut-être des sessions live"
end

# Premium
premium_count = Reward.where(reward_type: 'premium').count
if premium_count < 3
  puts "  🥇 Premium : Besoin de contenu premium (backstage, rencontres artistes)"
elsif premium_count < 6
  puts "  🥇 Premium : Bonne base, considérer des expériences VIP"
else
  puts "  🥇 Premium : Excellente variété, peut-être des événements spéciaux"
end

# Ultime
ultime_count = Reward.where(reward_type: 'ultime').count
if ultime_count < 2
  puts "  🌈 Ultime : Besoin de plus de récompenses ultimes (rencontres privées, expériences uniques)"
elsif ultime_count < 4
  puts "  🌈 Ultime : Bonne variété, considérer des expériences personnalisées"
else
  puts "  🌈 Ultime : Excellente gamme, peut-être des expériences sur mesure"
end

puts "\n🎯 Priorités d'amélioration :"
puts "  1. Vérifier la continuité des playlists challenge"
puts "  2. Équilibrer le contenu entre les types de récompenses"
puts "  3. Ajouter de la variété dans chaque catégorie"
puts "  4. Considérer des contenus saisonniers ou événementiels"
