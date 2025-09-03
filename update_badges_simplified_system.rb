#!/usr/bin/env ruby

puts "🔄 Mise à jour du système de badges vers le système simplifié..."
puts "=" * 60

# Supprimer dans l'ordre pour éviter les contraintes de clé étrangère
puts "🗑️  Suppression des UserBadge existants..."
UserBadge.destroy_all
puts "   ✅ UserBadge supprimés"

puts "🗑️  Suppression des BadgePlaylistUnlock existants..."
BadgePlaylistUnlock.destroy_all
puts "   ✅ BadgePlaylistUnlock supprimés"

# Supprimer tous les badges existants
puts "🗑️  Suppression des badges existants..."
Badge.destroy_all
puts "   ✅ Badges supprimés"

# Créer les nouveaux badges avec le système simplifié
puts "🏆 Création des nouveaux badges simplifiés..."

# Badges Competitor - Focus sur la régularité et les points totaux
[
  {
    name: 'Bronze Competitor',
    badge_type: 'competitor',
    level: 'bronze',
    points_required: 200,
    description: 'Vous commencez votre aventure !',
    reward_type: 'standard',
    reward_description: 'Accès à des statistiques détaillées',
    condition_1_type: 'regularity_points',
    condition_1_value: 100,  # 5 playlists/jour
    condition_2_type: 'total_points',
    condition_2_value: 200
  },
  {
    name: 'Silver Competitor',
    badge_type: 'competitor',
    level: 'silver',
    points_required: 600,
    description: 'Votre régularité paie !',
    reward_type: 'standard',
    reward_description: 'Photos dédicacées',
    condition_1_type: 'regularity_points',
    condition_1_value: 300,  # 15 playlists/jour
    condition_2_type: 'total_points',
    condition_2_value: 600
  },
  {
    name: 'Gold Competitor',
    badge_type: 'competitor',
    level: 'gold',
    points_required: 1200,
    description: 'Vous êtes un compétiteur d\'exception !',
    reward_type: 'premium',
    reward_description: 'Rencontre avec un artiste',
    condition_1_type: 'regularity_points',
    condition_1_value: 600,  # 30 playlists/jour
    condition_2_type: 'total_points',
    condition_2_value: 1200
  }
].each do |badge_attrs|
  Badge.create!(badge_attrs)
  puts "   ✅ #{badge_attrs[:name]} créé"
end

# Badges Engager - Focus sur le temps d'écoute et l'engagement
[
  {
    name: 'Bronze Engager',
    badge_type: 'engager',
    level: 'bronze',
    points_required: 150,
    description: 'Vous commencez à vous engager activement !',
    reward_type: 'standard',
    reward_description: 'Accès à des statistiques détaillées',
    condition_1_type: 'listening_points',
    condition_1_value: 90,  # 30 minutes d'écoute
    condition_2_type: 'critical_opinions',
    condition_2_value: 20   # Engagement avec opinions
  },
  {
    name: 'Silver Engager',
    badge_type: 'engager',
    level: 'silver',
    points_required: 450,
    description: 'Vous êtes un membre très actif !',
    reward_type: 'standard',
    reward_description: 'Photos dédicacées',
    condition_1_type: 'listening_points',
    condition_1_value: 300,  # 100 minutes d'écoute
    condition_2_type: 'critical_opinions',
    condition_2_value: 50   # Engagement soutenu
  },
  {
    name: 'Gold Engager',
    badge_type: 'engager',
    level: 'gold',
    points_required: 900,
    description: 'Vous êtes le cœur de la communauté !',
    reward_type: 'premium',
    reward_description: 'Rencontre avec un artiste',
    condition_1_type: 'listening_points',
    condition_1_value: 600,  # 200 minutes d'écoute
    condition_2_type: 'critical_opinions',
    condition_2_value: 100  # Engagement exceptionnel
  }
].each do |badge_attrs|
  Badge.create!(badge_attrs)
  puts "   ✅ #{badge_attrs[:name]} créé"
end

# Badges Critic - Focus sur la critique constructive
[
  {
    name: 'Bronze Critic',
    badge_type: 'critic',
    level: 'bronze',
    points_required: 100,
    description: 'Vous développez votre esprit critique !',
    reward_type: 'standard',
    reward_description: 'Accès à des statistiques détaillées',
    condition_1_type: 'critical_opinions',
    condition_1_value: 30,   # Critique constructive
    condition_2_type: 'listening_points',
    condition_2_value: 60    # Temps d'écoute minimum
  },
  {
    name: 'Silver Critic',
    badge_type: 'critic',
    level: 'silver',
    points_required: 300,
    description: 'Votre opinion fait autorité !',
    reward_type: 'standard',
    reward_description: 'Photos dédicacées',
    condition_1_type: 'critical_opinions',
    condition_1_value: 80,   # Critique avancée
    condition_2_type: 'listening_points',
    condition_2_value: 180   # Temps d'écoute soutenu
  },
  {
    name: 'Gold Critic',
    badge_type: 'critic',
    level: 'gold',
    points_required: 600,
    description: 'Vous êtes un critique reconnu !',
    reward_type: 'premium',
    reward_description: 'Rencontre avec un artiste',
    condition_1_type: 'critical_opinions',
    condition_1_value: 150,  # Critique exceptionnelle
    condition_2_type: 'listening_points',
    condition_2_value: 360   # Temps d'écoute exceptionnel
  }
].each do |badge_attrs|
  Badge.create!(badge_attrs)
  puts "   ✅ #{badge_attrs[:name]} créé"
end

# Badges Challenger - Focus sur la performance globale
[
  {
    name: 'Bronze Challenger',
    badge_type: 'challenger',
    level: 'bronze',
    points_required: 400,
    description: 'Vous relevez les défis !',
    reward_type: 'standard',
    reward_description: 'Accès à des statistiques détaillées',
    condition_1_type: 'total_points',
    condition_1_value: 400,
    condition_2_type: 'regularity_points',
    condition_2_value: 200,  # 10 playlists/jour
    condition_3_type: 'listening_points',
    condition_3_value: 150   # 50 minutes d'écoute
  },
  {
    name: 'Silver Challenger',
    badge_type: 'challenger',
    level: 'silver',
    points_required: 1000,
    description: 'Vous êtes un challenger redoutable !',
    reward_type: 'standard',
    reward_description: 'Photos dédicacées',
    condition_1_type: 'total_points',
    condition_1_value: 1000,
    condition_2_type: 'regularity_points',
    condition_2_value: 400,  # 20 playlists/jour
    condition_3_type: 'listening_points',
    condition_3_value: 300   # 100 minutes d'écoute
  },
  {
    name: 'Gold Challenger',
    badge_type: 'challenger',
    level: 'gold',
    points_required: 2000,
    description: 'Vous êtes un champion !',
    reward_type: 'premium',
    reward_description: 'Rencontre avec un artiste',
    condition_1_type: 'total_points',
    condition_1_value: 2000,
    condition_2_type: 'regularity_points',
    condition_2_value: 800,  # 40 playlists/jour
    condition_3_type: 'listening_points',
    condition_3_value: 600   # 200 minutes d'écoute
  }
].each do |badge_attrs|
  Badge.create!(badge_attrs)
  puts "   ✅ #{badge_attrs[:name]} créé"
end

puts "=" * 60
puts "✅ Système de badges simplifié créé avec succès !"
puts "📊 Total : #{Badge.count} badges créés"
puts "🎯 Types : Competitor, Engager, Critic, Challenger"
puts "🏅 Niveaux : Bronze, Silver, Gold"
puts "=" * 60

# Réattribuer les badges aux utilisateurs existants
puts "🔄 Réattribution des badges aux utilisateurs existants..."
User.all.each do |user|
  BadgeService.assign_badges(user)
  puts "   ✅ Badges réattribués pour #{user.email}"
end

puts "🎉 Mise à jour terminée avec succès !"
