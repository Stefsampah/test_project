# Script pour créer les badges avec les types de conditions autorisés
puts "🌟 Création des badges simplifiés..."

# Badges Competitor
[
  {
    name: 'Bronze Competitor',
    badge_type: 'competitor',
    level: 'bronze',
    points_required: 500,
    description: 'Vous commencez à vous démarquer !',
    reward_type: 'standard',
    reward_description: 'Accès anticipé à du contenu exclusif'
  },
  {
    name: 'Silver Competitor',
    badge_type: 'competitor',
    level: 'silver',
    points_required: 1500,
    description: 'Vous êtes un adversaire redoutable !',
    reward_type: 'standard',
    reward_description: 'Merchandising exclusif'
  },
  {
    name: 'Gold Competitor',
    badge_type: 'competitor',
    level: 'gold',
    points_required: 3000,
    description: 'Vous êtes le champion ultime !',
    reward_type: 'premium',
    reward_description: 'Invitation à un concert VIP'
  }
].each do |badge_attrs|
  Badge.create!(badge_attrs)
end

# Badges Engager
[
  {
    name: 'Bronze Engager',
    badge_type: 'engager',
    level: 'bronze',
    points_required: 200,
    description: 'Vous commencez à vous engager !',
    reward_type: 'standard',
    reward_description: 'Accès anticipé à du contenu exclusif'
  },
  {
    name: 'Silver Engager',
    badge_type: 'engager',
    level: 'silver',
    points_required: 800,
    description: 'Vous êtes très engagé !',
    reward_type: 'standard',
    reward_description: 'Merchandising exclusif'
  },
  {
    name: 'Gold Engager',
    badge_type: 'engager',
    level: 'gold',
    points_required: 2000,
    description: 'Vous êtes un super engagé !',
    reward_type: 'premium',
    reward_description: 'Invitation à un concert VIP'
  }
].each do |badge_attrs|
  Badge.create!(badge_attrs)
end

# Badges Critic
[
  {
    name: 'Bronze Critic',
    badge_type: 'critic',
    level: 'bronze',
    points_required: 300,
    description: 'Vous commencez à critiquer !',
    reward_type: 'standard',
    reward_description: 'Accès anticipé à du contenu exclusif'
  },
  {
    name: 'Silver Critic',
    badge_type: 'critic',
    level: 'silver',
    points_required: 1000,
    description: 'Vous êtes un bon critique !',
    reward_type: 'standard',
    reward_description: 'Merchandising exclusif'
  },
  {
    name: 'Gold Critic',
    badge_type: 'critic',
    level: 'gold',
    points_required: 2500,
    description: 'Vous êtes un critique expert !',
    reward_type: 'premium',
    reward_description: 'Invitation à un concert VIP'
  }
].each do |badge_attrs|
  Badge.create!(badge_attrs)
end

# Badges Challenger
[
  {
    name: 'Bronze Challenger',
    badge_type: 'challenger',
    level: 'bronze',
    points_required: 1000,
    description: 'Vous commencez à défier !',
    reward_type: 'standard',
    reward_description: 'Accès anticipé à du contenu exclusif'
  },
  {
    name: 'Silver Challenger',
    badge_type: 'challenger',
    level: 'silver',
    points_required: 2500,
    description: 'Vous êtes un défi redoutable !',
    reward_type: 'standard',
    reward_description: 'Merchandising exclusif'
  },
  {
    name: 'Gold Challenger',
    badge_type: 'challenger',
    level: 'gold',
    points_required: 5000,
    description: 'Vous êtes le défi ultime !',
    reward_type: 'premium',
    reward_description: 'Invitation à un concert VIP'
  }
].each do |badge_attrs|
  Badge.create!(badge_attrs)
end

puts "✅ #{Badge.count} badges créés avec succès !"
puts "\n📊 Répartition par type :"
Badge.group(:badge_type).count.each do |type, count|
  puts "- #{type.capitalize}: #{count} badges"
end

puts "\n🎯 Répartition par niveau :"
Badge.group(:level).count.each do |level, count|
  puts "- #{level.capitalize}: #{count} badges"
end
