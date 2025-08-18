class Reward < ApplicationRecord
  belongs_to :user
  
  validates :badge_type, presence: true
  validates :quantity_required, presence: true, numericality: { greater_than: 0 }
  validates :reward_type, presence: true
  validates :reward_description, presence: true
  validates :content_type, presence: true # Nouvelle validation pour content_type obligatoire
  
  enum reward_type: {
    challenge: 'challenge',
    exclusif: 'exclusif', 
    premium: 'premium',
    ultime: 'ultime'
  }
  
  # Types de contenu pour les récompenses digitales
  enum content_type: {
    playlist_exclusive: 'playlist_exclusive',
    playlist_acoustic: 'playlist_acoustic',
    playlist_remix: 'playlist_remix',
    podcast_exclusive: 'podcast_exclusive',
    blog_article: 'blog_article',
    documentary: 'documentary',
    reportage: 'reportage',
    audio_comments: 'audio_comments',
    studio_session: 'studio_session',
    exclusive_photos: 'exclusive_photos',
    backstage_video: 'backstage_video',
    concert_footage: 'concert_footage',
    personal_voice_message: 'personal_voice_message',
    dedicated_photo: 'dedicated_photo',
    concert_invitation: 'concert_invitation',
    challenge_reward_playlist_1: 'challenge_reward_playlist_1',
    challenge_reward_playlist_2: 'challenge_reward_playlist_2',
    challenge_reward_playlist_3: 'challenge_reward_playlist_3',
    challenge_reward_playlist_4: 'challenge_reward_playlist_4',
    challenge_reward_playlist_5: 'challenge_reward_playlist_5',
    challenge_reward_playlist_6: 'challenge_reward_playlist_6',
    challenge_reward_playlist_7: 'challenge_reward_playlist_7',
    challenge_reward_playlist_8: 'challenge_reward_playlist_8',
    challenge_reward_playlist_9: 'challenge_reward_playlist_9',
    challenge_reward_playlist_10: 'challenge_reward_playlist_10',
    challenge_reward_playlist_11: 'challenge_reward_playlist_11',
    challenge_reward_playlist_12: 'challenge_reward_playlist_12',
    challenge_reward_playlist_13: 'challenge_reward_playlist_13',
    challenge_reward_playlist_14: 'challenge_reward_playlist_14',
    challenge_reward_playlist_15: 'challenge_reward_playlist_15',
    # Nouveaux types de contenu exclusif
    rapivoire_ci: 'rapivoire_ci',
    my_afro_culture: 'my_afro_culture',
    afrikactus: 'afrikactus',
    baton_rouge_label: 'baton_rouge_label',
    danslaciudad: 'danslaciudad',
    culturap: 'culturap',
    pan_african_music: 'pan_african_music',
    popnews: 'popnews',
    citemag: 'citemag',
    generation_voyage: 'generation_voyage',
    okayplayer: 'okayplayer',
    pigeons_planes: 'pigeons_planes',
    bandcamp_daily: 'bandcamp_daily',
    underground_ivoire: 'underground_ivoire',
    le_type: 'le_type',
    madmoizelle: 'madmoizelle',
    radio_campus_france: 'radio_campus_france',
    la_souterraine: 'la_souterraine',
    le_tournedisque: 'le_tournedisque',
    # Documentaires exclusifs
    didi_b_interview: 'didi_b_interview',
    himra_legendes_urbaines: 'himra_legendes_urbaines',
    zoh_cataleya_serge_dioman: 'zoh_cataleya_serge_dioman',
    do_it_together: 'do_it_together',
    rumble_indians: 'rumble_indians',
    country_music_ken_burns: 'country_music_ken_burns',
    rap_odyssees_france_tv: 'rap_odyssees_france_tv',
    # Sessions studio exclusives
    himra_number_one_live: 'himra_number_one_live',
    didi_b_nouvelle_generation: 'didi_b_nouvelle_generation',
    zoh_cataleya_live_toura: 'zoh_cataleya_live_toura',
    bigyne_wiz_abe_sounogola: 'bigyne_wiz_abe_sounogola',
    didi_b_mhd_studio: 'didi_b_mhd_studio',
    didi_b_naira_marley: 'didi_b_naira_marley',
    didi_b_enregistrement: 'didi_b_enregistrement',
    werenoi_cstar_session: 'werenoi_cstar_session',
    himra_top_boy_live: 'himra_top_boy_live',
    timar_zz_lequel: 'timar_zz_lequel',
    octogone_philipayne: 'octogone_philipayne'
  }
  
  scope :by_badge_type, ->(badge_type) { where(badge_type: badge_type) }
  scope :unlocked, -> { where(unlocked: true) }
  scope :recent, -> { where('created_at >= ?', 30.days.ago) }
  scope :by_reward_type, ->(reward_type) { where(reward_type: reward_type) }
  
  # Système unifié : récompenses basées sur le total de badges avec content_type obligatoire
  def self.check_and_create_rewards_for_user(user)
    # Vérifier les récompenses unifiées avec système aléatoire
    check_random_rewards(user)
  end
  
  # Système de récompenses aléatoires avec anti-répétition
  def self.check_random_rewards(user)
    badge_count = user.user_badges.count
    created_rewards = []
    
    # Vérifier si l'utilisateur a la collection arc-en-ciel
    has_rainbow = user.has_rainbow_collection?
    
    # Débloquer les récompenses selon le nombre de badges (une seule par niveau)
    if badge_count >= 3 && !user.rewards.challenge.exists?
      reward = select_random_reward(user, 'challenge')
      created_rewards << reward if reward
    end
    
    if badge_count >= 6 && !user.rewards.exclusif.exists?
      reward = select_random_reward(user, 'exclusif')
      created_rewards << reward if reward
    end
    
    if badge_count >= 9 && !user.rewards.premium.exists?
      reward = select_random_reward(user, 'premium')
      created_rewards << reward if reward
    end
    
    if has_rainbow && !user.rewards.ultime.exists?
      reward = select_random_reward(user, 'ultime')
      created_rewards << reward if reward
    end
    
    created_rewards
  end
  
  # Sélection aléatoire avec anti-répétition
  def self.select_random_reward(user, level)
    # Récupérer les récompenses récentes de l'utilisateur pour éviter les doublons
    recent_rewards = user.rewards.recent.pluck(:content_type).compact
    
    # Définir les récompenses disponibles par niveau
    available_rewards = case level
    when 'challenge'
      [
        { content_type: 'challenge_reward_playlist_1', name: 'Challenge Reward Playlist 1', description: 'Playlist exclusive débloquée via les récompenses challenge', icon: '🏆' },
        { content_type: 'challenge_reward_playlist_2', name: 'Challenge Reward Playlist 2', description: 'Deuxième playlist exclusive débloquée via les récompenses challenge', icon: '🏆' },
        { content_type: 'challenge_reward_playlist_3', name: 'Challenge Reward Playlist 3', description: 'Troisième playlist exclusive débloquée via les récompenses challenge', icon: '🏆' },
        { content_type: 'challenge_reward_playlist_4', name: 'Challenge Reward Playlist 4', description: 'Quatrième playlist exclusive débloquée via les récompenses challenge', icon: '🏆' },
        { content_type: 'challenge_reward_playlist_5', name: 'Challenge Reward Playlist 5', description: 'Cinquième playlist exclusive débloquée via les récompenses challenge', icon: '🏆' },
        { content_type: 'challenge_reward_playlist_6', name: 'Challenge Reward Playlist Alternative 6', description: 'Sixième playlist exclusive débloquée via les récompenses challenge - Versions alternatives', icon: '🎤' },
        { content_type: 'challenge_reward_playlist_7', name: 'Challenge Reward Playlist Alternative 7', description: 'Septième playlist exclusive débloquée via les récompenses challenge - Versions alternatives', icon: '🎤' },
        { content_type: 'challenge_reward_playlist_8', name: 'Challenge Reward Playlist Alternative 8', description: 'Huitième playlist exclusive débloquée via les récompenses challenge - Versions alternatives', icon: '🎧' },
        { content_type: 'challenge_reward_playlist_9', name: 'Challenge Reward Playlist Alternative 9', description: 'Neuvième playlist exclusive débloquée via les récompenses challenge - Versions alternatives', icon: '🎧' },
        { content_type: 'challenge_reward_playlist_10', name: 'Challenge Reward Videos 10', description: 'Playlist exclusive de 10 titres hip-hop et R&B débloquée via les récompenses challenge', icon: '🎵' },
        { content_type: 'challenge_reward_playlist_11', name: 'Challenge Reward Videos 11', description: 'Playlist exclusive de remixes débloquée via les récompenses challenge', icon: '🎛️' },
        { content_type: 'challenge_reward_playlist_12', name: 'Challenge Reward Videos 12', description: 'Playlist exclusive de versions alternatives débloquée via les récompenses challenge', icon: '🎵' },
        { content_type: 'challenge_reward_playlist_13', name: 'Challenge Reward Videos 13', description: 'Playlist exclusive de versions live débloquée via les récompenses challenge', icon: '🎤' },
        { content_type: 'challenge_reward_playlist_14', name: 'Challenge Reward Videos 14', description: 'Playlist exclusive de versions instrumentales débloquée via les récompenses challenge', icon: '🎧' },
        { content_type: 'challenge_reward_playlist_15', name: 'Challenge Reward Videos 15', description: 'Playlist exclusive de versions exclusives débloquée via les récompenses challenge', icon: '⭐' }
      ]
    when 'exclusif'
      [
        # Blogs et Médias Spécialisés
        { content_type: 'rapivoire_ci', name: 'Rapivoire.ci', description: 'Média influent dédié au rap ivoirien - Artistes émergents', icon: '📝' },
        { content_type: 'my_afro_culture', name: 'My Afro Culture', description: 'Blog culturel sur les talents émergents (Himra, Widgunz, SK07, Ramba Junior, Agato, Mister Christ)', icon: '📝' },
        { content_type: 'afrikactus', name: 'Afrikactus', description: 'Focus sur le reggae ivoirien (Kajeem, Bonny B, Meiway, Bamba Ami Sarah, Ismaël Isaac)', icon: '📝' },
        { content_type: 'baton_rouge_label', name: 'Baton Rouge Label', description: 'Analyse des tendances musicales ivoiriennes : drill, afro-électro, rock, dancehall', icon: '📝' },
        { content_type: 'danslaciudad', name: 'DansLaCiudad', description: 'Média urbain français - Artistes émergents en pop urbaine, rap et afro', icon: '📝' },
        { content_type: 'culturap', name: 'Culturap', description: 'Média rap français - Scènes locales, notamment en Nouvelle-Aquitaine', icon: '📝' },
        { content_type: 'pan_african_music', name: 'Pan African Music', description: 'Artistes afro, reggae, hip-hop et indé en France et en Afrique', icon: '📝' },
        { content_type: 'popnews', name: 'POPnews', description: 'Webzine pop indé européen avec incursions dans le hip-hop et l\'afro', icon: '📝' },
        { content_type: 'citemag', name: 'CiteMag', description: 'Cultures urbaines européennes : musique, danse, streetwear', icon: '📝' },
        { content_type: 'generation_voyage', name: 'Generation Voyage', description: 'Guide des festivals hip-hop, afro et reggae en Europe', icon: '📝' },
        { content_type: 'okayplayer', name: 'Okayplayer', description: 'Média américain - Hip-hop, soul, afrobeat et indé', icon: '📝' },
        { content_type: 'pigeons_planes', name: 'Pigeons & Planes', description: 'Plateforme dédiée aux artistes émergents dans tous les genres urbains', icon: '📝' },
        { content_type: 'bandcamp_daily', name: 'Bandcamp Daily', description: 'Scènes locales et underground aux États-Unis avec focus régionaux', icon: '📝' },
        { content_type: 'le_type', name: 'Le Type', description: 'Média bordelais indépendant - Liste éclectique d\'artistes à suivre', icon: '📝' },
        { content_type: 'madmoizelle', name: 'Madmoizelle', description: 'Quatre artistes pas trop connus à Bordeaux', icon: '📝' },
        { content_type: 'radio_campus_france', name: 'Radio Campus France', description: 'Réseau de radios étudiantes - Artistes indés dans toutes les régions', icon: '📝' },
        { content_type: 'la_souterraine', name: 'La Souterraine', description: 'Artistes francophones émergents en podcast ou sessions live', icon: '📝' },
        { content_type: 'le_tournedisque', name: 'Le Tournedisque', description: 'Blog et podcast - Pépites musicales françaises hors des radars', icon: '📝' },
        
        # Podcasts Exclusifs
        { content_type: 'underground_ivoire', name: 'Underground Ivoire', description: 'Podcast dédié aux artistes émergents du rap ivoirien - Interviews, freestyles, coulisses', icon: '🎙️' },
        { content_type: 'podcast_exclusive', name: 'Podcast Exclusif', description: 'Interview exclusive d\'un artiste', icon: '🎙️' },
        
        # Documentaires Exclusifs
        { content_type: 'didi_b_interview', name: 'Interview Exclusive: Didi B', description: 'À cœur ouvert - Avant son concert au stade FHB, il se livre sur sa carrière et ses émotions', icon: '🎬' },
        { content_type: 'himra_legendes_urbaines', name: 'Himra dans Légendes Urbaines', description: 'Portrait complet avec des moments forts de sa carrière - Tiken Jah Fakoly x SDM', icon: '🎬' },
        { content_type: 'zoh_cataleya_serge_dioman', name: 'La Télé d\'Ici', description: 'Zoh Cataleya et Serge Dioman - Discussion sur son parcours et ses engagements', icon: '🎬' },
        { content_type: 'do_it_together', name: 'Do It Together', description: 'Tour du monde de la scène indé - Paris, Belgrade, Amsterdam - Évolution du DIY vers la création collective', icon: '🎬' },
        { content_type: 'rumble_indians', name: 'RUMBLE - The Indians Who Rocked the World', description: 'Documentaire primé à Sundance - Influence des musiciens amérindiens dans le rock et le blues', icon: '🎬' },
        { content_type: 'country_music_ken_burns', name: 'Country Music - Ken Burns', description: 'Histoire populaire des États-Unis - Johnny Cash à Reba McEntire - Fresque musicale et sociale', icon: '🎬' },
        { content_type: 'rap_odyssees_france_tv', name: 'Rap Odyssées - France TV', description: 'Portrait de quatre jeunes rappeurs bordelais en pleine ascension - Entre studio, scène et vie quotidienne', icon: '🎬' },
        { content_type: 'documentary', name: 'Documentaire', description: 'Documentaire musical exclusif', icon: '🎬' },
        
        # Commentaires Audio
        { content_type: 'audio_comments', name: 'Commentaires Audio', description: 'Artistes commentent leurs chansons - Analyses détaillées des paroles et histoires derrière les morceaux', icon: '🎧' },
        
        # Sessions Studio
        { content_type: 'himra_number_one_live', name: 'HIMRA - NUMBER ONE (Live Version)', description: 'Version live qui reflète l\'ambiance studio', icon: '🎹' },
        { content_type: 'didi_b_nouvelle_generation', name: 'DIDI B EN STUDIO AVEC LA NOUVELLE GÉNÉRATION', description: 'Session studio avec Didi B et d\'autres artistes', icon: '🎹' },
        { content_type: 'zoh_cataleya_live_toura', name: 'ZOH CATALEYA - LIVE TOURA DRILL 1', description: 'Performance live proche d\'une session studio', icon: '🎹' },
        { content_type: 'bigyne_wiz_abe_sounogola', name: 'Séance studio Bigyne Wiz', description: 'Abé sounôgôla - Session studio disponible', icon: '🎹' },
        { content_type: 'didi_b_mhd_studio', name: 'Didi B au studio avec MHD', description: 'Extrait studio avec MHD - Une exclu en pétard', icon: '🎹' },
        { content_type: 'didi_b_naira_marley', name: 'DIDI B FEAT NAIRA MARLEY', description: 'Du nouveau hits - Séance studio exclusif', icon: '🎹' },
        { content_type: 'didi_b_enregistrement', name: 'VOICI COMMENT DIDI B ENREGISTRE SES SONG', description: 'Session studio générale incluant Rodela', icon: '🎹' },
        { content_type: 'werenoi_cstar_session', name: 'Werenoi - CSTAR Session (live)', description: 'Location / Solitaire / Chemin d\'or - Session live', icon: '🎹' },
        { content_type: 'himra_top_boy_live', name: 'HIMRA - TOP BOY LIVE VERSION', description: 'Version live exclusive', icon: '🎹' },
        { content_type: 'timar_zz_lequel', name: 'Timar feat. ZZ - Lequel', description: 'EXCLU - Session studio exclusive', icon: '🎹' },
        { content_type: 'octogone_philipayne', name: 'OCTOGONE - PHILIPAYNE', description: 'Avec Enfant Noir, Le Couteau, Slai & BigGodzi', icon: '🎹' },
        { content_type: 'studio_session', name: 'Session Studio', description: 'Vidéo d\'enregistrement en studio', icon: '🎹' },
        
        # Reportages
        { content_type: 'reportage', name: 'Reportage', description: 'Reportage exclusif sur un artiste - Couverture des événements musicaux, interviews backstage, documentation des tournées', icon: '📺' }
      ]
    when 'premium'
      [
        { content_type: 'exclusive_photos', name: 'Photos Exclusives', description: 'Photos exclusives d\'artistes', icon: '📸' },
        { content_type: 'backstage_video', name: 'Vidéo Backstage', description: 'Vidéo backstage exclusive', icon: '🎭' },
        { content_type: 'concert_footage', name: 'Extrait Concert', description: 'Extrait exclusif d\'un concert', icon: '🎪' }
      ]
    when 'ultime'
      [
        { content_type: 'personal_voice_message', name: 'Message Vocal Personnalisé', description: 'Message vocal d\'un artiste pour vous', icon: '🎤' },
        { content_type: 'dedicated_photo', name: 'Photo Dédicacée', description: 'Photo dédicacée d\'un artiste', icon: '📷' },
        { content_type: 'concert_invitation', name: 'Invitation Concert', description: 'Invitation à un concert près de chez vous', icon: '🎫' }
      ]
    end
    
    # Filtrer les récompenses déjà obtenues récemment
    available_rewards = available_rewards.reject { |reward| recent_rewards.include?(reward[:content_type]) }
    
    # Si toutes les récompenses ont été obtenues récemment, réinitialiser
    if available_rewards.empty?
      available_rewards = case level
      when 'challenge'
        [
          { content_type: 'challenge_reward_playlist_1', name: 'Challenge Reward Playlist 1', description: 'Playlist exclusive débloquée via les récompenses challenge', icon: '🏆' },
          { content_type: 'challenge_reward_playlist_2', name: 'Challenge Reward Playlist 2', description: 'Deuxième playlist exclusive débloquée via les récompenses challenge', icon: '🏆' },
          { content_type: 'challenge_reward_playlist_3', name: 'Challenge Reward Playlist 3', description: 'Troisième playlist exclusive débloquée via les récompenses challenge', icon: '🏆' },
          { content_type: 'challenge_reward_playlist_4', name: 'Challenge Reward Playlist 4', description: 'Quatrième playlist exclusive débloquée via les récompenses challenge', icon: '🏆' },
          { content_type: 'challenge_reward_playlist_5', name: 'Challenge Reward Playlist 5', description: 'Cinquième playlist exclusive débloquée via les récompenses challenge', icon: '🏆' }
        ]
      when 'exclusif'
        [
          # Blogs et Médias Spécialisés
          { content_type: 'rapivoire_ci', name: 'Rapivoire.ci', description: 'Média influent dédié au rap ivoirien - Artistes émergents', icon: '📝' },
          { content_type: 'my_afro_culture', name: 'My Afro Culture', description: 'Blog culturel sur les talents émergents', icon: '📝' },
          { content_type: 'afrikactus', name: 'Afrikactus', description: 'Focus sur le reggae ivoirien', icon: '📝' },
          { content_type: 'baton_rouge_label', name: 'Baton Rouge Label', description: 'Analyse des tendances musicales ivoiriennes', icon: '📝' },
          { content_type: 'danslaciudad', name: 'DansLaCiudad', description: 'Média urbain français - Artistes émergents', icon: '📝' },
          { content_type: 'culturap', name: 'Culturap', description: 'Média rap français - Scènes locales', icon: '📝' },
          { content_type: 'pan_african_music', name: 'Pan African Music', description: 'Artistes afro, reggae, hip-hop et indé', icon: '📝' },
          { content_type: 'popnews', name: 'POPnews', description: 'Webzine pop indé européen', icon: '📝' },
          { content_type: 'citemag', name: 'CiteMag', description: 'Cultures urbaines européennes', icon: '📝' },
          { content_type: 'generation_voyage', name: 'Generation Voyage', description: 'Guide des festivals urbains', icon: '📝' },
          { content_type: 'okayplayer', name: 'Okayplayer', description: 'Média américain - Hip-hop, soul, afrobeat', icon: '📝' },
          { content_type: 'pigeons_planes', name: 'Pigeons & Planes', description: 'Artistes émergents dans tous les genres urbains', icon: '📝' },
          { content_type: 'bandcamp_daily', name: 'Bandcamp Daily', description: 'Scènes locales et underground', icon: '📝' },
          { content_type: 'le_type', name: 'Le Type', description: 'Média bordelais indépendant', icon: '📝' },
          { content_type: 'madmoizelle', name: 'Madmoizelle', description: 'Artistes bordelais', icon: '📝' },
          { content_type: 'radio_campus_france', name: 'Radio Campus France', description: 'Radios étudiantes - Artistes indés', icon: '📝' },
          { content_type: 'la_souterraine', name: 'La Souterraine', description: 'Artistes francophones émergents', icon: '📝' },
          { content_type: 'le_tournedisque', name: 'Le Tournedisque', description: 'Pépites musicales françaises', icon: '📝' },
          
          # Podcasts Exclusifs
          { content_type: 'underground_ivoire', name: 'Underground Ivoire', description: 'Podcast dédié aux artistes émergents du rap ivoirien', icon: '🎙️' },
          { content_type: 'podcast_exclusive', name: 'Podcast Exclusif', description: 'Interview exclusive d\'un artiste', icon: '🎙️' },
          
          # Documentaires Exclusifs
          { content_type: 'didi_b_interview', name: 'Interview Exclusive: Didi B', description: 'À cœur ouvert - Avant son concert au stade FHB', icon: '🎬' },
          { content_type: 'himra_legendes_urbaines', name: 'Himra dans Légendes Urbaines', description: 'Portrait complet avec des moments forts de sa carrière', icon: '🎬' },
          { content_type: 'zoh_cataleya_serge_dioman', name: 'La Télé d\'Ici', description: 'Zoh Cataleya et Serge Dioman', icon: '🎬' },
          { content_type: 'do_it_together', name: 'Do It Together', description: 'Tour du monde de la scène indé', icon: '🎬' },
          { content_type: 'rumble_indians', name: 'RUMBLE - The Indians Who Rocked the World', description: 'Documentaire primé à Sundance', icon: '🎬' },
          { content_type: 'country_music_ken_burns', name: 'Country Music - Ken Burns', description: 'Histoire populaire des États-Unis', icon: '🎬' },
          { content_type: 'rap_odyssees_france_tv', name: 'Rap Odyssées - France TV', description: 'Portrait de jeunes rappeurs bordelais', icon: '🎬' },
          { content_type: 'documentary', name: 'Documentaire', description: 'Documentaire musical exclusif', icon: '🎬' },
          
          # Commentaires Audio
          { content_type: 'audio_comments', name: 'Commentaires Audio', description: 'Artistes commentent leurs chansons', icon: '🎧' },
          
          # Sessions Studio
          { content_type: 'himra_number_one_live', name: 'HIMRA - NUMBER ONE (Live Version)', description: 'Version live qui reflète l\'ambiance studio', icon: '🎹' },
          { content_type: 'didi_b_nouvelle_generation', name: 'DIDI B EN STUDIO AVEC LA NOUVELLE GÉNÉRATION', description: 'Session studio avec Didi B et d\'autres artistes', icon: '🎹' },
          { content_type: 'zoh_cataleya_live_toura', name: 'ZOH CATALEYA - LIVE TOURA DRILL 1', description: 'Performance live proche d\'une session studio', icon: '🎹' },
          { content_type: 'bigyne_wiz_abe_sounogola', name: 'Séance studio Bigyne Wiz', description: 'Abé sounôgôla - Session studio disponible', icon: '🎹' },
          { content_type: 'didi_b_mhd_studio', name: 'Didi B au studio avec MHD', description: 'Extrait studio avec MHD - Une exclu en pétard', icon: '🎹' },
          { content_type: 'didi_b_naira_marley', name: 'DIDI B FEAT NAIRA MARLEY', description: 'Du nouveau hits - Séance studio exclusif', icon: '🎹' },
          { content_type: 'didi_b_enregistrement', name: 'VOICI COMMENT DIDI B ENREGISTRE SES SONG', description: 'Session studio générale incluant Rodela', icon: '🎹' },
          { content_type: 'werenoi_cstar_session', name: 'Werenoi - CSTAR Session (live)', description: 'Location / Solitaire / Chemin d\'or - Session live', icon: '🎹' },
          { content_type: 'himra_top_boy_live', name: 'HIMRA - TOP BOY LIVE VERSION', description: 'Version live exclusive', icon: '🎹' },
          { content_type: 'timar_zz_lequel', name: 'Timar feat. ZZ - Lequel', description: 'EXCLU - Session studio exclusive', icon: '🎹' },
          { content_type: 'octogone_philipayne', name: 'OCTOGONE - PHILIPAYNE', description: 'Avec Enfant Noir, Le Couteau, Slai & BigGodzi', icon: '🎹' },
          { content_type: 'studio_session', name: 'Session Studio', description: 'Vidéo d\'enregistrement en studio', icon: '🎹' },
          
          # Reportages
          { content_type: 'reportage', name: 'Reportage', description: 'Reportage exclusif sur un artiste', icon: '📺' }
        ]
      when 'premium'
        [
          { content_type: 'exclusive_photos', name: 'Photos Exclusives', description: 'Photos exclusives d\'artistes', icon: '📸' },
          { content_type: 'backstage_video', name: 'Vidéo Backstage', description: 'Vidéo backstage exclusive', icon: '🎭' }
        ]
      when 'ultime'
        [
          { content_type: 'personal_voice_message', name: 'Message Vocal Personnalisé', description: 'Message vocal d\'un artiste pour vous', icon: '🎤' },
          { content_type: 'dedicated_photo', name: 'Photo Dédicacée', description: 'Photo dédicacée d\'un artiste', icon: '📷' }
        ]
      end
    end
    
    # Sélectionner une récompense aléatoire
    selected_reward = available_rewards.sample
    
    # Créer la récompense avec content_type obligatoire
    reward = create!(
      user: user,
      reward_type: level,
      content_type: selected_reward[:content_type],
      reward_description: selected_reward[:description],
      quantity_required: case level
                        when 'challenge' then 3
                        when 'exclusif' then 6
                        when 'premium' then 9
                        when 'ultime' then 12
                        end,
      badge_type: 'unified',
      unlocked: true,
      unlocked_at: Time.current
    )
    
    # Débloquer automatiquement le contenu selon le niveau
    if level == 'challenge'
      unlock_challenge_playlists(user, selected_reward[:content_type])
    elsif level == 'exclusif'
      unlock_exclusif_content(user, selected_reward[:content_type])
    end
    
    reward
  end
  
  # Débloquer les playlists challenge selon la récompense obtenue
  def self.unlock_challenge_playlists(user, content_type)
    case content_type
    when 'challenge_reward_playlist_1'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🏆 Challenge Reward Playlist 1 débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_2'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🏆 Challenge Reward Playlist 2 débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_3'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🏆 Challenge Reward Playlist 3 débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_4'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🏆 Challenge Reward Playlist 4 débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_5'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🏆 Challenge Reward Playlist 5 débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_6'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🎤 Challenge Reward Playlist Alternative 6 débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_7'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🎤 Challenge Reward Playlist Alternative 7 débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_8'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🎧 Challenge Reward Playlist Alternative 8 débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_9'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🎧 Challenge Reward Playlist Alternative 9 débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_10'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🎵 Challenge Reward Videos 10 débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_11'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🎛️ Challenge Reward Videos 11 (Remixes) débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_12'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🎵 Challenge Reward Videos 12 (Versions alternatives) débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_13'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🎤 Challenge Reward Videos 13 (Versions live) débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_14'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "🎧 Challenge Reward Videos 14 (Versions instrumentales) débloquée comme récompense pour #{user.email}"
    when 'challenge_reward_playlist_15'
      # Ne pas débloquer la playlist dans le système de playlists
      # La récompense est gérée uniquement via le système de récompenses
      puts "⭐ Challenge Reward Videos 15 (Versions exclusives) débloquée comme récompense pour #{user.email}"
    end
  end

  # Débloquer le contenu exclusif selon la récompense obtenue
  def self.unlock_exclusif_content(user, content_type)
    case content_type
    # Blogs et Médias Spécialisés
    when 'rapivoire_ci'
      puts "📝 Rapivoire.ci débloqué comme récompense exclusive pour #{user.email}"
    when 'my_afro_culture'
      puts "📝 My Afro Culture débloqué comme récompense exclusive pour #{user.email}"
    when 'afrikactus'
      puts "📝 Afrikactus débloqué comme récompense exclusive pour #{user.email}"
    when 'baton_rouge_label'
      puts "📝 Baton Rouge Label débloqué comme récompense exclusive pour #{user.email}"
    when 'danslaciudad'
      puts "📝 DansLaCiudad débloqué comme récompense exclusive pour #{user.email}"
    when 'culturap'
      puts "📝 Culturap débloqué comme récompense exclusive pour #{user.email}"
    when 'pan_african_music'
      puts "📝 Pan African Music débloqué comme récompense exclusive pour #{user.email}"
    when 'popnews'
      puts "📝 POPnews débloqué comme récompense exclusive pour #{user.email}"
    when 'citemag'
      puts "📝 CiteMag débloqué comme récompense exclusive pour #{user.email}"
    when 'generation_voyage'
      puts "📝 Generation Voyage débloqué comme récompense exclusive pour #{user.email}"
    when 'okayplayer'
      puts "📝 Okayplayer débloqué comme récompense exclusive pour #{user.email}"
    when 'pigeons_planes'
      puts "📝 Pigeons & Planes débloqué comme récompense exclusive pour #{user.email}"
    when 'bandcamp_daily'
      puts "📝 Bandcamp Daily débloqué comme récompense exclusive pour #{user.email}"
    when 'le_type'
      puts "📝 Le Type débloqué comme récompense exclusive pour #{user.email}"
    when 'madmoizelle'
      puts "📝 Madmoizelle débloqué comme récompense exclusive pour #{user.email}"
    when 'radio_campus_france'
      puts "📝 Radio Campus France débloqué comme récompense exclusive pour #{user.email}"
    when 'la_souterraine'
      puts "📝 La Souterraine débloqué comme récompense exclusive pour #{user.email}"
    when 'le_tournedisque'
      puts "📝 Le Tournedisque débloqué comme récompense exclusive pour #{user.email}"
      
      # Podcasts Exclusifs
    when 'underground_ivoire'
      puts "🎙️ Underground Ivoire débloqué comme récompense exclusive pour #{user.email}"
    when 'podcast_exclusive'
      puts "🎙️ Podcast Exclusif débloqué comme récompense exclusive pour #{user.email}"
      
      # Documentaires Exclusifs
    when 'didi_b_interview'
      puts "🎬 Interview Exclusive: Didi B débloquée comme récompense exclusive pour #{user.email}"
    when 'himra_legendes_urbaines'
      puts "🎬 Himra dans Légendes Urbaines débloqué comme récompense exclusive pour #{user.email}"
    when 'zoh_cataleya_serge_dioman'
      puts "🎬 La Télé d'Ici débloquée comme récompense exclusive pour #{user.email}"
    when 'do_it_together'
      puts "🎬 Do It Together débloqué comme récompense exclusive pour #{user.email}"
    when 'rumble_indians'
      puts "🎬 RUMBLE - The Indians Who Rocked the World débloqué comme récompense exclusive pour #{user.email}"
    when 'country_music_ken_burns'
      puts "🎬 Country Music - Ken Burns débloqué comme récompense exclusive pour #{user.email}"
    when 'rap_odyssees_france_tv'
      puts "🎬 Rap Odyssées - France TV débloqué comme récompense exclusive pour #{user.email}"
    when 'documentary'
      puts "🎬 Documentaire débloqué comme récompense exclusive pour #{user.email}"
      
      # Commentaires Audio
    when 'audio_comments'
      puts "🎧 Commentaires Audio débloqués comme récompense exclusive pour #{user.email}"
      
      # Sessions Studio
    when 'himra_number_one_live'
      puts "🎹 HIMRA - NUMBER ONE (Live Version) débloquée comme récompense exclusive pour #{user.email}"
    when 'didi_b_nouvelle_generation'
      puts "🎹 DIDI B EN STUDIO AVEC LA NOUVELLE GÉNÉRATION débloquée comme récompense exclusive pour #{user.email}"
    when 'zoh_cataleya_live_toura'
      puts "🎹 ZOH CATALEYA - LIVE TOURA DRILL 1 débloquée comme récompense exclusive pour #{user.email}"
    when 'bigyne_wiz_abe_sounogola'
      puts "🎹 Séance studio Bigyne Wiz débloquée comme récompense exclusive pour #{user.email}"
    when 'didi_b_mhd_studio'
      puts "🎹 Didi B au studio avec MHD débloquée comme récompense exclusive pour #{user.email}"
    when 'didi_b_naira_marley'
      puts "🎹 DIDI B FEAT NAIRA MARLEY débloquée comme récompense exclusive pour #{user.email}"
    when 'didi_b_enregistrement'
      puts "🎹 VOICI COMMENT DIDI B ENREGISTRE SES SONG débloquée comme récompense exclusive pour #{user.email}"
    when 'werenoi_cstar_session'
      puts "🎹 Werenoi - CSTAR Session débloquée comme récompense exclusive pour #{user.email}"
    when 'himra_top_boy_live'
      puts "🎹 HIMRA - TOP BOY LIVE VERSION débloquée comme récompense exclusive pour #{user.email}"
    when 'timar_zz_lequel'
      puts "🎹 Timar feat. ZZ - Lequel débloquée comme récompense exclusive pour #{user.email}"
    when 'octogone_philipayne'
      puts "🎹 OCTOGONE - PHILIPAYNE débloquée comme récompense exclusive pour #{user.email}"
    when 'studio_session'
      puts "🎹 Session Studio débloquée comme récompense exclusive pour #{user.email}"
      
      # Reportages
    when 'reportage'
      puts "📺 Reportage débloqué comme récompense exclusive pour #{user.email}"
    end
  end
  
  # Récupérer les playlists challenge débloquées par un utilisateur
  def self.challenge_playlists_for_user(user)
    challenge_rewards = user.rewards.where(content_type: ['challenge_reward_playlist_1', 'challenge_reward_playlist_2', 'challenge_reward_playlist_3', 'challenge_reward_playlist_4', 'challenge_reward_playlist_5', 'challenge_reward_playlist_6', 'challenge_reward_playlist_7', 'challenge_reward_playlist_8', 'challenge_reward_playlist_9', 'challenge_reward_playlist_10', 'challenge_reward_playlist_11', 'challenge_reward_playlist_12', 'challenge_reward_playlist_13', 'challenge_reward_playlist_14', 'challenge_reward_playlist_15'])
    
    playlists = []
    challenge_rewards.each do |reward|
      case reward.content_type
      when 'challenge_reward_playlist_1'
        playlist = Playlist.find_by(title: 'Challenge Reward Playlist 1')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_2'
        playlist = Playlist.find_by(title: 'Challenge Reward Playlist 2')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_3'
        playlist = Playlist.find_by(title: 'Challenge Reward Playlist 3')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_4'
        playlist = Playlist.find_by(title: 'Challenge Reward Playlist 4')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_5'
        playlist = Playlist.find_by(title: 'Challenge Reward Playlist 5')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_6'
        playlist = Playlist.find_by(title: 'Challenge Reward Playlist Alternative 6')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_7'
        playlist = Playlist.find_by(title: 'Challenge Reward Playlist Alternative 7')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_8'
        playlist = Playlist.find_by(title: 'Challenge Reward Playlist Alternative 8')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_9'
        playlist = Playlist.find_by(title: 'Challenge Reward Playlist Alternative 9')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_10'
        playlist = Playlist.find_by(title: 'Challenge Reward Videos 10')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_11'
        playlist = Playlist.find_by(title: 'Challenge Reward Videos 11')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_12'
        playlist = Playlist.find_by(title: 'Challenge Reward Videos 12')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_13'
        playlist = Playlist.find_by(title: 'Challenge Reward Videos 13')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_14'
        playlist = Playlist.find_by(title: 'Challenge Reward Videos 14')
        playlists << playlist if playlist
      when 'challenge_reward_playlist_15'
        playlist = Playlist.find_by(title: 'Challenge Reward Videos 15')
        playlists << playlist if playlist
      end
    end
    
    playlists
  end
  
  # Récompenses unifiées basées sur le total de badges
  def self.check_unified_rewards(user)
    total_badges = user.user_badges.count
    
    # Récompenses unifiées : 3, 6, 9, 12 badges
    [3, 6, 9, 12].each do |required_count|
      next if total_badges < required_count
      
      reward_type = case required_count
                   when 3 then 'challenge'
                   when 6 then 'exclusif'
                   when 9 then 'premium'
                   when 12 then 'ultime'
                   end
      
      check_reward_condition(user, 'unified', required_count, reward_type, "unified")
    end
  end
  
  # Méthode pour vérifier si une récompense peut être débloquée
  def can_be_unlocked?(user)
    case reward_category
    when 'unified'
      total_badges = user.user_badges.count
      total_badges >= quantity_required
    else
      false
    end
  end
  
  # Méthode pour obtenir la progression actuelle
  def current_progress(user)
    case reward_category
    when 'unified'
      user.user_badges.count
    else
      0
    end
  end
  
  # Méthode pour obtenir le pourcentage de progression
  def progress_percentage(user)
    current = current_progress(user)
    [(current.to_f / quantity_required * 100), 100].min
  end
  
  # Méthode pour obtenir le prochain niveau de récompense
  def self.next_reward_level(user, category)
    case category
    when 'unified'
      total_badges = user.user_badges.count
      case total_badges
      when 0..2 then { level: 'challenge', required: 3, current: total_badges, remaining: 3 - total_badges }
      when 3..5 then { level: 'exclusif', required: 6, current: total_badges, remaining: 6 - total_badges }
      when 6..8 then { level: 'premium', required: 9, current: total_badges, remaining: 9 - total_badges }
      when 9..11 then { level: 'ultime', required: 12, current: total_badges, remaining: 12 - total_badges }
      else { level: 'max', required: 12, current: total_badges, remaining: 0 }
      end
    end
  end
  
  private
  
  def reward_category
    # Catégorie unifiée pour toutes les récompenses
    'unified'
  end
  
  # Obtenir l'icône de la récompense
  def icon
    case content_type
    when 'playlist_exclusive', 'playlist_acoustic', 'playlist_remix'
      '🎵'
    when 'podcast_exclusive'
      '🎙️'
    when 'blog_article'
      '📝'
    when 'documentary'
      '🎬'
    when 'reportage'
      '📺'
    when 'audio_comments'
      '🎧'
    when 'studio_session'
      '🎹'
    when 'exclusive_photos', 'dedicated_photo'
      '📸'
    when 'backstage_video'
      '🎭'
    when 'concert_footage', 'concert_invitation'
      '🎪'
    when 'personal_voice_message'
      '🎤'
    when 'challenge_reward_playlist_1', 'challenge_reward_playlist_2'
      '🏆'
    else
      '🎁'
    end
  end
  
  # Obtenir la couleur de la récompense selon le niveau
  def color
    case reward_type
    when 'challenge'
      '#FFD700' # Or
    when 'exclusif'
      '#C0C0C0' # Argent
    when 'premium'
      '#CD7F32' # Bronze
    when 'ultime'
      '#FF69B4' # Rose vif
    else
      '#808080' # Gris
    end
  end
  
  def self.check_reward_condition(user, badge_type, quantity_required, reward_type, category)
    # Vérifier si la récompense existe déjà (par reward_type uniquement)
    existing_reward = user.rewards.find_by(reward_type: reward_type)
    
    return if existing_reward&.unlocked?
    
    # Si une récompense existe mais n'est pas débloquée, la débloquer
    if existing_reward && !existing_reward.unlocked?
      existing_reward.update!(unlocked: true, unlocked_at: Time.current)
      return existing_reward
    end
    
    # Créer une nouvelle récompense avec content_type obligatoire
    reward_data = select_random_reward_data(reward_type)
    
    reward = user.rewards.create!(
      badge_type: badge_type,
      quantity_required: quantity_required,
      reward_type: reward_type,
      content_type: reward_data[:content_type],
      reward_description: reward_data[:description],
      unlocked: true,
      unlocked_at: Time.current
    )
    
    reward
  end
  
  # Nouvelle méthode pour sélectionner les données de récompense
  def self.select_random_reward_data(reward_type)
    case reward_type
    when 'challenge'
      available_rewards = [
        { content_type: 'challenge_reward_playlist_1', description: 'Playlist exclusive débloquée via les récompenses challenge' },
        { content_type: 'challenge_reward_playlist_2', description: 'Deuxième playlist exclusive débloquée via les récompenses challenge' },
        { content_type: 'challenge_reward_playlist_3', description: 'Troisième playlist exclusive débloquée via les récompenses challenge' },
        { content_type: 'challenge_reward_playlist_4', description: 'Quatrième playlist exclusive débloquée via les récompenses challenge' },
        { content_type: 'challenge_reward_playlist_5', description: 'Cinquième playlist exclusive débloquée via les récompenses challenge' }
      ]
    when 'exclusif'
      available_rewards = [
        { content_type: 'podcast_exclusive', description: 'Interview exclusive d\'un artiste' },
        { content_type: 'blog_article', description: 'Article spécialisé sur la musique' },
        { content_type: 'documentary', description: 'Documentaire musical exclusif' }
      ]
    when 'premium'
      available_rewards = [
        { content_type: 'exclusive_photos', description: 'Photos exclusives d\'artistes' },
        { content_type: 'backstage_video', description: 'Vidéo backstage exclusive' }
      ]
    when 'ultime'
      available_rewards = [
        { content_type: 'personal_voice_message', description: 'Message vocal d\'un artiste pour vous' },
        { content_type: 'dedicated_photo', description: 'Photo dédicacée d\'un artiste' }
      ]
    else
      available_rewards = [
        { content_type: 'playlist_exclusive', description: 'Playlist exclusive' }
      ]
    end
    
    available_rewards.sample
  end
  
  def self.generate_reward_description(badge_type, quantity, reward_type, category)
    case reward_type
    when 'challenge'
      "#{quantity} badges - Accès anticipé et codes promo débloqués"
    when 'exclusif'
      "#{quantity} badges - Photos dédicacées et contenu exclusif débloqués"
    when 'premium'
      "#{quantity} badges - Rencontres artistes et backstage virtuel débloqués"
    when 'ultime'
      "#{quantity} badges - Rencontre privée et backstage réel débloqués"
    end
  end
end 