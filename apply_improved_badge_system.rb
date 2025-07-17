#!/usr/bin/env ruby
# Script pour appliquer le système de badges amélioré
# À exécuter avec: rails runner apply_improved_badge_system.rb

puts "🚀 Application du système de badges amélioré..."
puts "=" * 50

# 1. Appliquer la migration
puts "\n📦 Application de la migration..."
system("rails db:migrate")

# 2. Vérifier que les nouvelles colonnes existent
puts "\n🔍 Vérification des nouvelles colonnes..."
if Badge.column_names.include?('condition_1_type')
  puts "✅ Colonnes des conditions multiples ajoutées avec succès"
else
  puts "❌ Erreur: Les colonnes des conditions multiples n'existent pas"
  puts "Vérifiez que la migration a été appliquée correctement"
  exit 1
end

# 3. Supprimer les anciens badges
puts "\n🗑️  Suppression des anciens badges..."
old_badge_count = Badge.count
Badge.destroy_all
puts "✅ #{old_badge_count} anciens badges supprimés"

# 4. Créer les nouveaux badges avec conditions multiples
puts "\n🌟 Création des nouveaux badges améliorés..."

# Badges Competitor - Focus sur la performance et la compétition
[
  {
    name: 'Bronze Competitor',
    badge_type: 'competitor',
    level: 'bronze',
    points_required: 500,
    description: 'Un début solide dans la compétition !',
    reward_type: 'standard',
    reward_description: 'Accès à une playlist exclusive',
    condition_1_type: 'points_earned',
    condition_1_value: 500,
    condition_2_type: 'games_played',
    condition_2_value: 3,
    condition_3_type: 'win_ratio',
    condition_3_value: 50
  },
  {
    name: 'Silver Competitor',
    badge_type: 'competitor',
    level: 'silver',
    points_required: 1500,
    description: 'Vous devenez un compétiteur redoutable !',
    reward_type: 'standard',
    reward_description: 'Photos dédicacées',
    condition_1_type: 'points_earned',
    condition_1_value: 1500,
    condition_2_type: 'top_3_count',
    condition_2_value: 2,
    condition_3_type: 'win_ratio',
    condition_3_value: 60
  },
  {
    name: 'Gold Competitor',
    badge_type: 'competitor',
    level: 'gold',
    points_required: 3000,
    description: 'Vous êtes un champion incontesté !',
    reward_type: 'premium',
    reward_description: 'Invitation à un concert VIP',
    condition_1_type: 'points_earned',
    condition_1_value: 3000,
    condition_2_type: 'top_3_count',
    condition_2_value: 5,
    condition_3_type: 'consecutive_wins',
    condition_3_value: 3
  }
].each do |badge_attrs|
  Badge.create!(badge_attrs)
end

# Badges Engager - Focus sur l'engagement et la participation
[
  {
    name: 'Bronze Engager',
    badge_type: 'engager',
    level: 'bronze',
    points_required: 200,
    description: 'Vous commencez à vous engager activement !',
    reward_type: 'standard',
    reward_description: 'Accès à des statistiques détaillées',
    condition_1_type: 'games_played',
    condition_1_value: 5,
    condition_2_type: 'unique_playlists',
    condition_2_value: 2,
    condition_3_type: 'points_earned',
    condition_3_value: 200
  },
  {
    name: 'Silver Engager',
    badge_type: 'engager',
    level: 'silver',
    points_required: 800,
    description: 'Vous êtes un membre très actif !',
    reward_type: 'standard',
    reward_description: 'Photos dédicacées',
    condition_1_type: 'games_played',
    condition_1_value: 15,
    condition_2_type: 'unique_playlists',
    condition_2_value: 5,
    condition_3_type: 'win_ratio',
    condition_3_value: 55
  },
  {
    name: 'Gold Engager',
    badge_type: 'engager',
    level: 'gold',
    points_required: 2000,
    description: 'Vous êtes le cœur de la communauté !',
    reward_type: 'premium',
    reward_description: 'Rencontre avec un artiste',
    condition_1_type: 'games_played',
    condition_1_value: 30,
    condition_2_type: 'unique_playlists',
    condition_2_value: 8,
    condition_3_type: 'consecutive_wins',
    condition_3_value: 5
  }
].each do |badge_attrs|
  Badge.create!(badge_attrs)
end

# Badges Critic - Focus sur la qualité des choix
[
  {
    name: 'Bronze Critic',
    badge_type: 'critic',
    level: 'bronze',
    points_required: 300,
    description: 'Vos opinions sont valorisées !',
    reward_type: 'standard',
    reward_description: 'Accès à du contenu exclusif',
    condition_1_type: 'games_played',
    condition_1_value: 3,
    condition_2_type: 'win_ratio',
    condition_2_value: 60,
    condition_3_type: 'points_earned',
    condition_3_value: 300
  },
  {
    name: 'Silver Critic',
    badge_type: 'critic',
    level: 'silver',
    points_required: 1000,
    description: 'Votre goût est impeccable !',
    reward_type: 'standard',
    reward_description: 'Photos dédicacées',
    condition_1_type: 'games_played',
    condition_1_value: 10,
    condition_2_type: 'win_ratio',
    condition_2_value: 70,
    condition_3_type: 'top_3_count',
    condition_3_value: 3
  },
  {
    name: 'Gold Critic',
    badge_type: 'critic',
    level: 'gold',
    points_required: 2500,
    description: 'Vous êtes un vrai connaisseur !',
    reward_type: 'premium',
    reward_description: 'Participation à des interviews live',
    condition_1_type: 'games_played',
    condition_1_value: 20,
    condition_2_type: 'win_ratio',
    condition_2_value: 80,
    condition_3_type: 'consecutive_wins',
    condition_3_value: 7
  }
].each do |badge_attrs|
  Badge.create!(badge_attrs)
end

# Badges Challenger - Focus sur l'excellence globale
[
  {
    name: 'Bronze Challenger',
    badge_type: 'challenger',
    level: 'bronze',
    points_required: 1000,
    description: 'Vous grimpez dans les rangs !',
    reward_type: 'standard',
    reward_description: 'Accès anticipé à du contenu exclusif',
    condition_1_type: 'points_earned',
    condition_1_value: 1000,
    condition_2_type: 'unique_playlists',
    condition_2_value: 3,
    condition_3_type: 'win_ratio',
    condition_3_value: 65
  },
  {
    name: 'Silver Challenger',
    badge_type: 'challenger',
    level: 'silver',
    points_required: 2500,
    description: 'Vous êtes un adversaire redoutable !',
    reward_type: 'standard',
    reward_description: 'Merchandising exclusif',
    condition_1_type: 'points_earned',
    condition_1_value: 2500,
    condition_2_type: 'top_3_count',
    condition_2_value: 4,
    condition_3_type: 'consecutive_wins',
    condition_3_value: 4
  },
  {
    name: 'Gold Challenger',
    badge_type: 'challenger',
    level: 'gold',
    points_required: 5000,
    description: 'Vous êtes le champion ultime !',
    reward_type: 'premium',
    reward_description: 'Invitation à un concert VIP',
    condition_1_type: 'points_earned',
    condition_1_value: 5000,
    condition_2_type: 'top_3_count',
    condition_2_value: 8,
    condition_3_type: 'consecutive_wins',
    condition_3_value: 10
  }
].each do |badge_attrs|
  Badge.create!(badge_attrs)
end

puts "✅ #{Badge.count} badges améliorés créés avec succès !"

# 5. Vérifier les badges créés
puts "\n📊 Répartition par type :"
Badge.group(:badge_type).count.each do |type, count|
  puts "- #{type.capitalize}: #{count} badges"
end

puts "\n🎯 Conditions utilisées :"
Badge.all.each do |badge|
  puts "- #{badge.name}: #{badge.conditions_description}"
end

# 6. Réattribuer les badges aux utilisateurs existants
puts "\n👥 Réattribution des badges aux utilisateurs existants..."
User.all.each do |user|
  puts "Traitement de #{user.email}..."
  BadgeService.assign_badges(user)
  earned_count = user.user_badges.count
  puts "  ✅ #{earned_count} badges attribués"
end

puts "\n🎉 Système de badges amélioré appliqué avec succès !"
puts "\n📈 Améliorations apportées :"
puts "- Seuils réduits et plus accessibles"
puts "- Conditions multiples pour chaque badge"
puts "- Progression visible pour chaque condition"
puts "- Système plus engageant et moins démotivant"
puts "- Logique claire : Performance + Engagement + Qualité" 