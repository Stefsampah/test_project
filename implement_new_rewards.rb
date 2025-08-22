#!/usr/bin/env ruby

puts "🚀 IMPLÉMENTATION DES NOUVELLES RÉCOMPENSES MANQUANTES"
puts "=" * 80

require_relative 'config/environment'

# Configuration des nouveaux contenus à ajouter
new_rewards_data = {
  # NIVEAU PREMIUM (9 badges requis) - Vidéos backstage exclusives
  'backstage_videos' => [
    {
      content_type: 'backstage_didi_b_felicia',
      reward_description: 'Backstage exclusif du concert historique de Didi B au Félicia',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.youtube.com/watch?v=0tJz8JjPbHU',
      video_id: '0tJz8JjPbHU',
      artist: 'Didi B',
      event: 'Concert au Félicia',
      date: '2025-05-05',
      duration: '15:30',
      category: 'backstage_exclusif'
    },
    {
      content_type: 'backstage_didi_b_bouake',
      reward_description: 'Coulisses du weekend mouvementé de Didi B à Bouaké',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.youtube.com/watch?v=QVvfSQP3JLM',
      video_id: 'QVvfSQP3JLM',
      artist: 'Didi B',
      event: 'Show à Bouaké',
      date: '2025-06-10',
      duration: '12:45',
      category: 'backstage_exclusif'
    },
    {
      content_type: 'backstage_charles_dore',
      reward_description: 'Petit backstage exclusif de Charles Doré en coulisses',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.tiktok.com/@charlesdoreoff/video/7503591891099782422',
      video_id: 'tiktok_backstage_charles',
      artist: 'Charles Doré',
      event: 'Coulisses concert',
      date: '2025-01-15',
      duration: '2:30',
      category: 'backstage_exclusif'
    },
    {
      content_type: 'backstage_carbonne_imagine',
      reward_description: 'Backstage de la création de "Imagine" par Carbonne',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.tiktok.com/@carbonne14/video/7368891186821500193',
      video_id: 'tiktok_backstage_carbonne',
      artist: 'Carbonne',
      event: 'Création Imagine',
      date: '2024-12-20',
      duration: '3:15',
      category: 'backstage_exclusif'
    },
    {
      content_type: 'backstage_fredz_extraordinaire',
      reward_description: 'Rencontre exclusive en coulisses avec Fredz',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.tiktok.com/@fredz_musicc/video/7522179102992796933',
      video_id: 'tiktok_backstage_fredz',
      artist: 'Fredz',
      event: 'Coulisses Extraordinaire',
      date: '2025-01-20',
      duration: '4:20',
      category: 'backstage_exclusif'
    },
    {
      content_type: 'backstage_adele_robin',
      reward_description: 'Moments backstage avant la performance live d\'Adèle & Robin',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.facebook.com/adeleetrobin/videos/-avec-toi-dispo-partout-/761655883058254/',
      video_id: 'facebook_backstage_adele_robin',
      artist: 'Adèle & Robin',
      event: 'Nuit incolore',
      date: '2024-11-15',
      duration: '5:10',
      category: 'backstage_exclusif'
    },
    {
      content_type: 'backstage_victorien_star_academy',
      reward_description: 'Victorien en pleine préparation studio pour Star Academy',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.tiktok.com/@victorien.musique/video/7376642381904383265',
      video_id: 'tiktok_backstage_victorien',
      artist: 'Victorien',
      event: 'Préparation Star Academy',
      date: '2024-10-30',
      duration: '3:45',
      category: 'backstage_exclusif'
    },
    {
      content_type: 'backstage_miki_particule',
      reward_description: 'Coulisses du tournage du clip "Particule" de Miki',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.tiktok.com/@simonemedia/video/7514733593004952854',
      video_id: 'tiktok_backstage_miki',
      artist: 'Miki',
      event: 'Tournage Particule',
      date: '2024-08-15',
      duration: '6:20',
      category: 'backstage_exclusif'
    },
    {
      content_type: 'backstage_marguerite_coming_out',
      reward_description: 'Backstage du clip "Les filles, les meufs" avec message fort',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.tiktok.com/@tetumag/video/7519092466759552278',
      video_id: 'tiktok_backstage_marguerite',
      artist: 'Marguerite',
      event: 'Clip Les filles, les meufs',
      date: '2024-09-10',
      duration: '4:15',
      category: 'backstage_exclusif'
    },
    {
      content_type: 'backstage_marine_coeur_maladroit',
      reward_description: 'Marine dévoile les coulisses du clip "Cœur Maladroit"',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.tiktok.com/@marinedmusique/video/7517969307591085334',
      video_id: 'tiktok_backstage_marine',
      artist: 'Marine',
      event: 'Clip Cœur Maladroit',
      date: '2024-09-05',
      duration: '3:50',
      category: 'backstage_exclusif'
    }
  ],

  # NIVEAU PREMIUM (9 badges requis) - Performances live exclusives
  'live_performances' => [
    {
      content_type: 'live_english_teacher_bilbao',
      reward_description: 'Concert filmé au Bilbao BBK Live 2025 - English Teacher',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.youtube.com/watch?v=oAGHSWLZRyM',
      video_id: 'oAGHSWLZRyM',
      artist: 'English Teacher',
      event: 'Bilbao BBK Live 2025',
      date: '2025-07-10',
      duration: '45:20',
      category: 'performance_live_exclusive'
    },
    {
      content_type: 'live_himra_number_one',
      reward_description: 'HIMRA - NUMBER ONE (Live Version) en studio',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.youtube.com/watch?v=hn35k3R9Ja4',
      video_id: 'hn35k3R9Ja4',
      artist: 'HIMRA',
      event: 'Session studio live',
      date: '2024-12-15',
      duration: '4:15',
      category: 'performance_live_exclusive'
    },
    {
      content_type: 'live_zoh_cataleya_toura_drill',
      reward_description: 'ZOH CATALEYA - LIVE TOURA DRILL 1 en performance live',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.youtube.com/watch?v=e0sVW6DjgbU',
      video_id: 'e0sVW6DjgbU',
      artist: 'Zoh Cataleya',
      event: 'Performance Toura Drill',
      date: '2024-11-20',
      duration: '3:45',
      category: 'performance_live_exclusive'
    },
    {
      content_type: 'live_werenoi_cstar_session',
      reward_description: 'Werenoi - Location/Solitaire/Chemin d\'or | CSTAR Session live',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.youtube.com/watch?v=2Q-ZZG-SPvU',
      video_id: '2Q-ZZG-SPvU',
      artist: 'Werenoi',
      event: 'CSTAR Session live',
      date: '2024-10-25',
      duration: '12:30',
      category: 'performance_live_exclusive'
    },
    {
      content_type: 'live_himra_top_boy',
      reward_description: 'HIMRA - TOP BOY LIVE VERSION en performance exclusive',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.youtube.com/watch?v=NHqgPK7BlJk',
      video_id: 'NHqgPK7BlJk',
      artist: 'HIMRA',
      event: 'Performance Top Boy',
      date: '2024-09-15',
      duration: '4:20',
      category: 'performance_live_exclusive'
    },
    {
      content_type: 'live_timar_zz_lequel',
      reward_description: 'EXCLU Timar feat. ZZ - Lequel en performance live',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.youtube.com/watch?v=umTlEIX0GFI',
      video_id: 'umTlEIX0GFI',
      artist: 'Timar feat. ZZ',
      event: 'Performance exclusive',
      date: '2024-08-30',
      duration: '3:55',
      category: 'performance_live_exclusive'
    },
    {
      content_type: 'live_octogone_philipayne',
      reward_description: 'OCTOGONE - PHILIPAYNE avec Enfant Noir, Le Couteau, Slai & BigGodzi',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.youtube.com/watch?v=Fnez6Uc4J6o',
      video_id: 'Fnez6Uc4J6o',
      artist: 'Octogone',
      event: 'Performance collective',
      date: '2024-07-20',
      duration: '5:10',
      category: 'performance_live_exclusive'
    },
    {
      content_type: 'live_rico_nasty_tiny_desk',
      reward_description: 'Rico Nasty: Tiny Desk Concert - Performance intimiste',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.youtube.com/watch?v=kfUcI82SZv4',
      video_id: 'kfUcI82SZv4',
      artist: 'Rico Nasty',
      event: 'Tiny Desk Concert',
      date: '2024-06-15',
      duration: '18:45',
      category: 'performance_live_exclusive'
    },
    {
      content_type: 'live_coi_leray_no_more_parties',
      reward_description: 'Coi Leray - No More Parties (Live Session) | Vevo Ctrl',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.youtube.com/watch?v=pgS9ba7QLLQ',
      video_id: 'pgS9ba7QLLQ',
      artist: 'Coi Leray',
      event: 'Vevo Ctrl Session',
      date: '2024-05-10',
      duration: '4:30',
      category: 'performance_live_exclusive'
    },
    {
      content_type: 'live_victorien_fille_du_bar',
      reward_description: 'Victorien - La fille du bar (Rush live) à La Boule Noire',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.youtube.com/watch?v=1hAgC1wTb4U',
      video_id: '1hAgC1wTb4U',
      artist: 'Victorien',
      event: 'La Boule Noire - 22/06/2024',
      date: '2024-06-22',
      duration: '6:15',
      category: 'performance_live_exclusive'
    }
  ],

  # NIVEAU PREMIUM (9 badges requis) - Photos exclusives d'artistes NFT (5 de plus)
  'nft_photos' => [
    {
      content_type: 'nft_photo_didi_b_studio',
      reward_description: 'Photo exclusive NFT de Didi B en studio',
      badge_type: 'unified',
      quantity_required: 9,
      image_url: 'https://example.com/didi_b_studio_nft.jpg',
      artist: 'Didi B',
      location: 'Studio d\'enregistrement',
      date: '2025-01-15',
      rarity: 'Rare',
      category: 'photo_nft_exclusive'
    },
    {
      content_type: 'nft_photo_himra_performance',
      reward_description: 'Photo exclusive NFT de Himra en performance live',
      badge_type: 'unified',
      quantity_required: 9,
      image_url: 'https://example.com/himra_performance_nft.jpg',
      artist: 'Himra',
      location: 'Scène de concert',
      date: '2025-01-20',
      rarity: 'Épique',
      category: 'photo_nft_exclusive'
    },
    {
      content_type: 'nft_photo_zoh_cataleya_backstage',
      reward_description: 'Photo exclusive NFT de Zoh Cataleya en coulisses',
      badge_type: 'unified',
      quantity_required: 9,
      image_url: 'https://example.com/zoh_cataleya_backstage_nft.jpg',
      artist: 'Zoh Cataleya',
      location: 'Coulisses concert',
      date: '2025-01-25',
      rarity: 'Rare',
      category: 'photo_nft_exclusive'
    },
    {
      content_type: 'nft_photo_english_teacher_bilbao',
      reward_description: 'Photo exclusive NFT d\'English Teacher au Bilbao BBK Live',
      badge_type: 'unified',
      quantity_required: 9,
      image_url: 'https://example.com/english_teacher_bilbao_nft.jpg',
      artist: 'English Teacher',
      location: 'Bilbao BBK Live 2025',
      date: '2025-07-10',
      rarity: 'Légendaire',
      category: 'photo_nft_exclusive'
    },
    {
      content_type: 'nft_photo_werenoi_cstar',
      reward_description: 'Photo exclusive NFT de Werenoi en session CSTAR',
      badge_type: 'unified',
      quantity_required: 9,
      image_url: 'https://example.com/werenoi_cstar_nft.jpg',
      artist: 'Werenoi',
      location: 'Studio CSTAR',
      date: '2025-01-30',
      rarity: 'Rare',
      category: 'photo_nft_exclusive'
    }
  ],

  # NIVEAU PREMIUM (9 badges requis) - Contenu coulisses (10 récompenses)
  'coulisses_content' => [
    {
      content_type: 'coulisses_didi_b_studio_process',
      reward_description: 'Coulisses du processus d\'enregistrement de Didi B',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.youtube.com/watch?v=YCs4vMwOVwc',
      video_id: 'YCs4vMwOVwc',
      artist: 'Didi B',
      event: 'Processus d\'enregistrement',
      date: '2024-12-10',
      duration: '8:45',
      category: 'coulisses_exclusives'
    },
    {
      content_type: 'coulisses_himra_album_creation',
      reward_description: 'Coulisses de la création de l\'album IDK2 par Himra',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.youtube.com/watch?v=EQg95B_DhxU',
      video_id: 'EQg95B_DhxU',
      artist: 'Himra',
      event: 'Création album IDK2',
      date: '2024-11-25',
      duration: '12:20',
      category: 'coulisses_exclusives'
    },
    {
      content_type: 'coulisses_zoh_cataleya_parcours',
      reward_description: 'Coulisses du parcours et des engagements de Zoh Cataleya',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.youtube.com/watch?v=K3I1WR1zhAQ',
      video_id: 'K3I1WR1zhAQ',
      artist: 'Zoh Cataleya',
      event: 'Parcours artistique',
      date: '2024-10-15',
      duration: '15:30',
      category: 'coulisses_exclusives'
    },
    {
      content_type: 'coulisses_bleu_soleil_soleil_bleu',
      reward_description: 'Coulisses du hit Soleil Bleu par Bleu Soleil et Luiza',
      badge_type: 'unified',
      quantity_required: 9,
      video_link: 'https://video.lefigaro.fr/figaro/video/le-duo-bleu-soleil-et-la-chanteuse-luiza-racontent-les-coulisses-du-hit-soleil-bleu/',
      artist: 'Bleu Soleil & Luiza',
      event: 'Création Soleil Bleu',
      date: '2024-09-20',
      duration: '6:45',
      category: 'coulisses_exclusives'
    },
    {
      content_type: 'coulisses_timeo_derniere_danse',
      reward_description: 'Coulisses de la reprise Dernière Danse par TIMEO',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.youtube.com/watch?v=C28dFl-Uhpk',
      video_id: 'C28dFl-Uhpk',
      artist: 'TIMEO',
      event: 'Reprise Dernière Danse',
      date: '2024-08-30',
      duration: '4:15',
      category: 'coulisses_exclusives'
    },
    {
      content_type: 'coulisses_jeck_carla_rencontre',
      reward_description: 'Coulisses de la rencontre et collaboration Jeck & Carla',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.youtube.com/watch?v=_cGwtwohEDU',
      video_id: '_cGwtwohEDU',
      artist: 'Jeck & Carla',
      event: 'Rencontre et collaboration',
      date: '2024-07-25',
      duration: '9:30',
      category: 'coulisses_exclusives'
    },
    {
      content_type: 'coulisses_anais_mva_ep_remede',
      reward_description: 'Coulisses de l\'EP Remède et inspirations d\'Anaïs MVA',
      badge_type: 'unified',
      quantity_required: 9,
      content_description: 'Confidences sur son EP et ses inspirations musicales',
      artist: 'Anaïs MVA',
      event: 'EP Remède',
      date: '2024-06-15',
      duration: '7:20',
      category: 'coulisses_exclusives'
    },
    {
      content_type: 'coulisses_julien_lieb_podcast',
      reward_description: 'Podcast intime avec Julien Lieb sur son parcours',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://m.youtube.com/watch?v=70qgVoLmits',
      video_id: '70qgVoLmits',
      artist: 'Julien Lieb',
      event: 'Podcast intime',
      date: '2024-05-20',
      duration: '25:15',
      category: 'coulisses_exclusives'
    },
    {
      content_type: 'coulisses_filiz_insomnie',
      reward_description: 'Réflexions personnelles de FILIZ sur la vie et le monde',
      badge_type: 'unified',
      quantity_required: 9,
      content_description: 'Confession poétique sur la jeunesse et l\'anxiété',
      artist: 'FILIZ',
      event: 'Réflexions personnelles',
      date: '2024-04-10',
      duration: '5:45',
      category: 'coulisses_exclusives'
    },
    {
      content_type: 'coulisses_mattyeux_vhs',
      reward_description: 'La passion discrète de Mattyeux pour la musique',
      badge_type: 'unified',
      quantity_required: 9,
      youtube_link: 'https://www.tiktok.com/@mouv/video/7507546126220823830',
      video_id: 'tiktok_coulisses_mattyeux',
      artist: 'Mattyeux',
      event: 'Passion musicale',
      date: '2024-03-25',
      duration: '3:30',
      category: 'coulisses_exclusives'
    }
  ]
}

puts "\n📊 ANALYSE DES NOUVELLES RÉCOMPENSES À CRÉER"
puts "-" * 60

total_new_rewards = 0
new_rewards_data.each do |category, rewards|
  puts "\n🎯 #{category.upcase} : #{rewards.count} récompenses"
  total_new_rewards += rewards.count
end

puts "\n🎯 TOTAL NOUVELLES RÉCOMPENSES : #{total_new_rewards}"
puts "📈 RÉCOMPENSES ACTUELLES : #{Reward.count}"
puts "🎯 TOTAL FINAL : #{Reward.count + total_new_rewards}"

puts "\n🚀 DÉBUT DE L'IMPLÉMENTATION"
puts "=" * 60

# Fonction pour créer une récompense avec gestion des erreurs
def create_reward_with_metadata(data, reward_type)
  begin
    # Vérifier si la récompense existe déjà
    existing_reward = Reward.find_by(
      reward_type: reward_type,
      content_type: data[:content_type],
      badge_type: data[:badge_type],
      quantity_required: data[:quantity_required]
    )
    
    if existing_reward
      puts "   ⚠️  Récompense existante : #{data[:content_type]} (ID: #{existing_reward.id})"
      return existing_reward
    end
    
    # Créer la nouvelle récompense
    reward = Reward.create!(
      user_id: 1, # Utilisateur par défaut
      badge_type: data[:badge_type],
      quantity_required: data[:quantity_required],
      reward_type: reward_type,
      reward_description: data[:reward_description],
      unlocked: false,
      content_type: data[:content_type],
      claimed: false
    )
    
    puts "   ✅ Créée : #{data[:content_type]} (ID: #{reward.id})"
    return reward
    
  rescue => e
    puts "   ❌ Erreur création #{data[:content_type]}: #{e.message}"
    return nil
  end
end

# Créer les nouvelles récompenses par catégorie
new_rewards_data.each do |category, rewards|
  puts "\n🎯 CRÉATION DES RÉCOMPENSES : #{category.upcase}"
  puts "-" * 50
  
  rewards.each do |reward_data|
    create_reward_with_metadata(reward_data, 'premium')
  end
end

puts "\n🎉 IMPLÉMENTATION TERMINÉE !"
puts "=" * 60

# Vérification finale
puts "\n📊 VÉRIFICATION FINALE"
puts "-" * 40

puts "🎯 Total récompenses après implémentation : #{Reward.count}"
puts "🥈 Récompenses exclusives : #{Reward.where(reward_type: 'exclusif').count}"
puts "🥇 Récompenses premium : #{Reward.where(reward_type: 'premium').count}"
puts "🌈 Récompenses ultimes : #{Reward.where(reward_type: 'ultime').count}"
puts "🥉 Récompenses challenge : #{Reward.where(reward_type: 'challenge').count}"

puts "\n✅ NOUVELLES RÉCOMPENSES CRÉÉES AVEC SUCCÈS !"
puts "🎮 Votre système de récompenses est maintenant enrichi et équilibré !"
