# Seeds pour les badges améliorés avec conditions multiples
# À exécuter après la migration des conditions multiples

puts "🌟 Création des badges améliorés avec conditions multiples..."

# Supprimer les anciens badges pour les remplacer
Badge.destroy_all

# Badges Competitor - Focus sur la performance et la compétition
[
  {
    name: 'Bronze Competitor',
    badge_type: 'competitor',
    level: 'bronze',
    points_required: 500, # Seuil réduit
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
puts "\n📊 Répartition par type :"
Badge.group(:badge_type).count.each do |type, count|
  puts "- #{type.capitalize}: #{count} badges"
end

puts "\n🎯 Conditions utilisées :"
Badge.all.each do |badge|
  puts "- #{badge.name}: #{badge.conditions_description}"
end 