#!/usr/bin/env ruby
# Script pour corriger les badges avec les nouvelles conditions logiques

puts "🎯 CORRECTION DES CONDITIONS DE BADGES"
puts "=" * 50

# Charger l'environnement Rails
require_relative 'config/environment'

# 1. Supprimer tous les badges existants pour repartir proprement
puts "\n🗑️  Suppression des badges existants..."

# Supprimer dans l'ordre pour éviter les contraintes de clé étrangère
puts "   - Suppression des UserBadge..."
UserBadge.destroy_all

puts "   - Suppression des BadgePlaylistUnlock..."
if defined?(BadgePlaylistUnlock)
  BadgePlaylistUnlock.destroy_all
end

puts "   - Suppression des Badge..."
Badge.destroy_all

puts "✅ Badges supprimés"

# 2. Créer les nouveaux badges avec des conditions logiques
puts "\n🏆 Création des nouveaux badges..."

# Badges Competitor - Focus sur la performance
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
    condition_2_value: 3
  },
  {
    name: 'Silver Competitor',
    badge_type: 'competitor',
    level: 'silver',
    points_required: 1500,
    description: 'Vous devenez une force avec laquelle compter !',
    reward_type: 'standard',
    reward_description: 'Photos dédicacées',
    condition_1_type: 'points_earned',
    condition_1_value: 1500,
    condition_2_type: 'win_ratio',
    condition_2_value: 50
  },
  {
    name: 'Gold Competitor',
    badge_type: 'competitor',
    level: 'gold',
    points_required: 3000,
    description: 'Un vrai champion de la compétition !',
    reward_type: 'premium',
    reward_description: 'Invitation à un concert VIP',
    condition_1_type: 'points_earned',
    condition_1_value: 3000,
    condition_2_type: 'top_3_count',
    condition_2_value: 5
  }
].each do |badge_attrs|
  Badge.create!(badge_attrs)
  puts "   ✅ #{badge_attrs[:name]} créé"
end

# Badges Engager - Focus sur l'engagement et la diversité
[
  {
    name: 'Bronze Engager',
    badge_type: 'engager',
    level: 'bronze',
    points_required: 300,
    description: 'Vous commencez à vous engager activement !',
    reward_type: 'standard',
    reward_description: 'Accès à des statistiques détaillées',
    condition_1_type: 'points_earned',
    condition_1_value: 300,
    condition_2_type: 'genres_explored',
    condition_2_value: 2
  },
  {
    name: 'Silver Engager',
    badge_type: 'engager',
    level: 'silver',
    points_required: 800,
    description: 'Votre engagement fait des vagues !',
    reward_type: 'standard',
    reward_description: 'Photos dédicacées',
    condition_1_type: 'points_earned',
    condition_1_value: 800,
    condition_2_type: 'genres_explored',
    condition_2_value: 3,
    condition_3_type: 'completed_playlists',
    condition_3_value: 2
  },
  {
    name: 'Gold Engager',
    badge_type: 'engager',
    level: 'gold',
    points_required: 1500,
    description: 'Vous êtes le cœur de la communauté !',
    reward_type: 'premium',
    reward_description: 'Rencontre avec un artiste',
    condition_1_type: 'points_earned',
    condition_1_value: 1500,
    condition_2_type: 'genres_explored',
    condition_2_value: 4,
    condition_3_type: 'completed_playlists',
    condition_3_value: 5
  }
].each do |badge_attrs|
  Badge.create!(badge_attrs)
  puts "   ✅ #{badge_attrs[:name]} créé"
end

# Badges Critic - Focus sur la qualité et la diversité
[
  {
    name: 'Bronze Critic',
    badge_type: 'critic',
    level: 'bronze',
    points_required: 300,
    description: 'Vos opinions sont valorisées !',
    reward_type: 'standard',
    reward_description: 'Accès à du contenu exclusif',
    condition_1_type: 'points_earned',
    condition_1_value: 300,
    condition_2_type: 'performance_diversity',
    condition_2_value: 2
  },
  {
    name: 'Silver Critic',
    badge_type: 'critic',
    level: 'silver',
    points_required: 1000,
    description: 'Votre goût est impeccable !',
    reward_type: 'standard',
    reward_description: 'Photos dédicacées',
    condition_1_type: 'points_earned',
    condition_1_value: 1000,
    condition_2_type: 'performance_diversity',
    condition_2_value: 3,
    condition_3_type: 'genres_explored',
    condition_3_value: 3
  },
  {
    name: 'Gold Critic',
    badge_type: 'critic',
    level: 'gold',
    points_required: 2000,
    description: 'Vous êtes un vrai connaisseur !',
    reward_type: 'premium',
    reward_description: 'Participation à des interviews live',
    condition_1_type: 'points_earned',
    condition_1_value: 2000,
    condition_2_type: 'performance_diversity',
    condition_2_value: 5,
    condition_3_type: 'genres_explored',
    condition_3_value: 4
  }
].each do |badge_attrs|
  Badge.create!(badge_attrs)
  puts "   ✅ #{badge_attrs[:name]} créé"
end

# Badges Challenger - Focus sur la progression et les défis
[
  {
    name: 'Bronze Challenger',
    badge_type: 'challenger',
    level: 'bronze',
    points_required: 500,
    description: 'Vous grimpez dans les rangs !',
    reward_type: 'standard',
    reward_description: 'Accès anticipé à du contenu exclusif',
    condition_1_type: 'points_earned',
    condition_1_value: 500,
    condition_2_type: 'consecutive_wins',
    condition_2_value: 2
  },
  {
    name: 'Silver Challenger',
    badge_type: 'challenger',
    level: 'silver',
    points_required: 1200,
    description: 'Vous êtes un adversaire redoutable !',
    reward_type: 'standard',
    reward_description: 'Merchandising exclusif',
    condition_1_type: 'points_earned',
    condition_1_value: 1200,
    condition_2_type: 'consecutive_wins',
    condition_2_value: 3,
    condition_3_type: 'top_3_count',
    condition_3_value: 3
  },
  {
    name: 'Gold Challenger',
    badge_type: 'challenger',
    level: 'gold',
    points_required: 2500,
    description: 'Vous êtes le champion ultime !',
    reward_type: 'premium',
    reward_description: 'Invitation à un concert VIP',
    condition_1_type: 'points_earned',
    condition_1_value: 2500,
    condition_2_type: 'consecutive_wins',
    condition_2_value: 5,
    condition_3_type: 'top_3_count',
    condition_3_value: 8
  }
].each do |badge_attrs|
  Badge.create!(badge_attrs)
  puts "   ✅ #{badge_attrs[:name]} créé"
end

# 3. Mettre à jour les images des badges
puts "\n🖼️  Mise à jour des images des badges..."

badge_images = {
  'competitor' => {
    'bronze' => 'dropmixpop.webp',
    'silver' => 'NFT.jpg',
    'gold' => 'VIP-gold.jpg'
  },
  'engager' => {
    'bronze' => 'pandora-playlist-collage.webp',
    'silver' => 'photos-dedicacees.jpeg',
    'gold' => 'concert-virtuel.jpg'
  },
  'critic' => {
    'bronze' => 'Best-Music.webp',
    'silver' => 'artist_message.jpeg',
    'gold' => 'backstage_virtuel.jpg'
  },
  'challenger' => {
    'bronze' => 'Exclusive_content.jpeg',
    'silver' => 'music_merch.jpeg',
    'gold' => 'interview.jpg'
  }
}

badge_images.each do |badge_type, levels|
  levels.each do |level, image|
    badge = Badge.find_by(badge_type: badge_type, level: level)
    if badge
      badge.update(image: image)
      puts "   ✅ Image mise à jour pour #{badge.name}"
    end
  end
end

# 4. Tester avec TestUser
puts "\n🧪 Test avec TestUser..."

test_user = User.find_by(email: 'test@example.com')
if test_user
  puts "   📊 TestUser trouvé: #{test_user.email}"
  puts "   📈 Points totaux: #{test_user.total_points}"
  puts "   🎮 Parties jouées: #{test_user.games.count}"
  puts "   🎵 Genres explorés: #{test_user.genres_explored_count}"
  puts "   ✅ Playlists complétées: #{test_user.completed_playlists_count}"
  puts "   🏆 Diversité performance: #{test_user.performance_diversity}"
  
  # Vérifier quels badges TestUser devrait avoir
  Badge.all.each do |badge|
    if badge.conditions_met?(test_user)
      puts "   🎯 #{badge.name}: ÉLIGIBLE"
    else
      puts "   ❌ #{badge.name}: Non éligible"
    end
  end
else
  puts "   ⚠️  TestUser non trouvé"
end

puts "\n✅ CORRECTION TERMINÉE !"
puts "🎯 Les badges ont maintenant des conditions logiques et cohérentes"
puts "📊 TestUser peut maintenant gagner des badges légitimement" 