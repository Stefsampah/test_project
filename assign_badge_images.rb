#!/usr/bin/env ruby
# Script pour assigner des images aux badges
# À exécuter avec: rails runner assign_badge_images.rb

puts "🎨 Attribution des images aux badges..."

# Mapping des badges vers les images
badge_images = {
  'Bronze Competitor' => 'dropmixpop.webp',
  'Silver Competitor' => 'pandora-playlist-collage.webp',
  'Gold Competitor' => 'VIP-gold.jpg',
  
  'Bronze Engager' => 'artist_message.jpeg',
  'Silver Engager' => 'photos-dedicacees.jpeg',
  'Gold Engager' => 'artist-meeting.jpeg',
  
  'Bronze Critic' => 'Exclusive_content.jpeg',
  'Silver Critic' => 'photos-dedicacees.jpeg',
  'Gold Critic' => 'interview.jpg',
  
  'Bronze Challenger' => 'concert.jpeg',
  'Silver Challenger' => 'music_merch.jpeg',
  'Gold Challenger' => 'concert-virtuel.jpg'
}

# Assigner les images aux badges
Badge.all.each do |badge|
  if badge_images[badge.name]
    badge.update!(image: badge_images[badge.name])
    puts "✅ #{badge.name} -> #{badge_images[badge.name]}"
  else
    puts "⚠️  Pas d'image trouvée pour #{badge.name}"
  end
end

puts "\n🎉 Attribution des images terminée !"
puts "📊 Badges avec images : #{Badge.where.not(image: nil).count}/#{Badge.count}" 