class RewardsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    redirect_to my_rewards_path
  end
  
  def my_rewards
    # Récupérer uniquement les récompenses débloquées
    @rewards = current_user.rewards.where(unlocked: true).order(created_at: :desc)
    @unlocked_rewards = @rewards
    
    # Grouper par niveau de récompense pour l'affichage (uniquement débloquées)
    @challenge_rewards = @rewards.where(reward_type: 'challenge')
    @exclusif_rewards = @rewards.where(reward_type: 'exclusif')
    @premium_rewards = @rewards.where(reward_type: 'premium')
    @ultime_rewards = @rewards.where(reward_type: 'ultime')
    
    # Calculer la prochaine récompense accessible
    @next_accessible_reward = calculate_next_accessible_reward(current_user)
    
    # Statistiques des badges par type
    @badge_counts = {}
    Badge.distinct.pluck(:badge_type).each do |badge_type|
      @badge_counts[badge_type] = current_user.user_badges.joins(:badge).where(badges: { badge_type: badge_type }).count
    end
    
    # Statistiques par niveau
    @bronze_count = current_user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    @silver_count = current_user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    @gold_count = current_user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
    @total_badges = current_user.user_badges.count
    
    # Progression vers la prochaine récompense
    @progress = current_user.progress_to_next_digital_reward
    @next_level = current_user.next_digital_reward_level
  end
  
  def all_rewards
    # Récupérer toutes les récompenses de l'utilisateur
    @user_rewards = current_user.rewards.order(:badge_type, :quantity_required)
    @rewards_by_type = @user_rewards.group_by(&:badge_type)
    
    # Statistiques des badges par type
    @badge_counts = {}
    Badge.distinct.pluck(:badge_type).each do |badge_type|
      @badge_counts[badge_type] = current_user.user_badges.joins(:badge).where(badges: { badge_type: badge_type }).count
    end
    
    # Statistiques globales
    @total_rewards = Reward.count
    @unlocked_rewards = Reward.unlocked.count
    @locked_rewards = Reward.where(unlocked: false).count
  end
  
  def show
    @reward = current_user.rewards.find(params[:id])
    
    # Si c'est une récompense challenge, récupérer la playlist associée
    if @reward.content_type&.start_with?('challenge_reward_playlist')
      playlist_title = case @reward.content_type
                      when 'challenge_reward_playlist_1' then 'Challenge Reward Playlist 1'
                      when 'challenge_reward_playlist_2' then 'Challenge Reward Playlist 2'
                      when 'challenge_reward_playlist_3' then 'Challenge Reward Playlist 3'
                      when 'challenge_reward_playlist_4' then 'Challenge Reward Playlist 4'
                      when 'challenge_reward_playlist_5' then 'Challenge Reward Playlist 5'
                      when 'challenge_reward_playlist_6' then 'Challenge Reward Playlist 6'
                      when 'challenge_reward_playlist_7' then 'Challenge Reward Playlist 7'
                      when 'challenge_reward_playlist_8' then 'Challenge Reward Playlist 8'
                      when 'challenge_reward_playlist_9' then 'Challenge Reward Playlist 9'
                      when 'challenge_reward_playlist_10' then 'Challenge Reward Playlist 10'
                      when 'challenge_reward_playlist_11' then 'Challenge Reward Playlist 11'
                      when 'challenge_reward_playlist_12' then 'Challenge Reward Playlist 12'
                      when 'challenge_reward_playlist_13' then 'Challenge Reward Playlist 13'
                      when 'challenge_reward_playlist_14' then 'Challenge Reward Playlist 14'
                      when 'challenge_reward_playlist_15' then 'Challenge Reward Playlist 15'
                      end
      
      @playlist = Playlist.find_by(title: playlist_title) if playlist_title
    end
    
    # Si c'est une récompense exclusive, récupérer les détails du contenu
    if @reward.reward_type == 'exclusif'
      @exclusif_content = get_exclusif_content_details(@reward.content_type)
    end
  end
  
  private
  
  def get_exclusif_content_details(content_type)
    case content_type
    # Blogs et Médias Spécialisés
    when 'rapivoire_ci'
      {
        title: 'Rapivoire.ci',
        description: 'Média influent dédié au rap ivoirien - Artistes émergents',
        icon: '📝',
        color: 'from-orange-400 to-red-500',
        link: 'https://2024.rapivoire.ci/10-rappeurs-a-suivre-rap-ivoire-2024/',
        link_text: 'Voir le contenu',
        type: 'Blog et Média'
      }
    when 'my_afro_culture'
      {
        title: 'My Afro Culture',
        description: 'Blog culturel sur les talents émergents (Himra, Widgunz, SK07, Ramba Junior, Agato, Mister Christ)',
        icon: '📝',
        color: 'from-purple-400 to-blue-500',
        link: 'https://myafroculture.com/les-6-rappeurs-ivoiriens-qui-montent/',
        link_text: 'Voir le contenu',
        type: 'Blog et Média'
      }
    when 'afrikactus'
      {
        title: 'Afrikactus',
        description: 'Focus sur le reggae ivoirien (Kajeem, Bonny B, Meiway, Bamba Ami Sarah, Ismaël Isaac)',
        icon: '📝',
        color: 'from-yellow-400 to-orange-500',
        link: 'https://afrikactus.com/reggae-ivoirien-5-artistes-emergents-qui-revolutionnent-la-scene-musicale-africaine/',
        link_text: 'Voir le contenu',
        type: 'Blog et Média'
      }
    when 'baton_rouge_label'
      {
        title: 'Baton Rouge Label',
        description: 'Analyse des tendances musicales ivoiriennes : drill, afro-électro, rock, dancehall',
        icon: '📝',
        color: 'from-purple-400 to-pink-500',
        link: 'https://batonrougelabel.com/blogs/conseils-pour-reussir-dans-l-industrie-musicale/la-cote-divoire-une-scene-musicale-en-pleine-mutation',
        link_text: 'Voir le contenu',
        type: 'Blog et Média'
      }
    when 'pan_african_music'
      {
        title: 'Pan African Music',
        description: 'Excellent pour suivre les artistes afro, reggae, hip-hop et indé en France et en Afrique',
        icon: '📝',
        color: 'from-yellow-400 to-orange-500',
        link: 'https://pan-african-music.com/',
        link_text: 'Voir le contenu',
        type: 'Blog et Média'
      }
    when 'generation_voyage'
      {
        title: 'Generation Voyage',
        description: 'Guide des festivals hip-hop, afro et reggae en Europe',
        icon: '📝',
        color: 'from-blue-400 to-indigo-500',
        link: 'https://generationvoyage.fr/festivals-musiques-urbaines-europe/',
        link_text: 'Voir le contenu',
        type: 'Blog et Média'
      }
    when 'pigeons_planes'
      {
        title: 'Pigeons & Planes',
        description: 'Plateforme dédiée aux artistes émergents dans tous les genres urbains',
        icon: '📝',
        color: 'from-red-400 to-pink-500',
        link: 'https://www.complex.com/pigeons-and-planes/',
        link_text: 'Voir le contenu',
        type: 'Blog et Média'
      }
    when 'bandcamp_daily'
      {
        title: 'Bandcamp Daily',
        description: 'Blog qui explore les scènes locales et underground aux États-Unis, avec des focus régionaux',
        icon: '📝',
        color: 'from-purple-400 to-blue-500',
        link: 'https://daily.bandcamp.com/',
        link_text: 'Voir le contenu',
        type: 'Blog et Média'
      }
    when 'le_type'
      {
        title: 'Le Type',
        description: 'Ce média bordelais indépendant propose une liste éclectique d\'artistes à suivre',
        icon: '📝',
        color: 'from-purple-400 to-indigo-500',
        link: 'https://letype.fr/24-artistes-a-suivre-en-2024-a-bordeaux/',
        link_text: 'Voir le contenu',
        type: 'Blog et Média'
      }
    when 'radio_campus_france'
      {
        title: 'Radio Campus France',
        description: 'Réseau de radios étudiantes qui interviewe des artistes indés dans toutes les régions',
        icon: '📝',
        color: 'from-blue-400 to-purple-500',
        link: 'https://www.radiocampus.fr/emissions',
        link_text: 'Voir le contenu',
        type: 'Blog et Média'
      }
    when 'la_souterraine'
      {
        title: 'La Souterraine',
        description: 'Plateforme qui diffuse des artistes francophones émergents, souvent en podcast ou sessions live',
        icon: '📝',
        color: 'from-gray-400 to-gray-600',
        link: 'https://souterraine.biz/',
        link_text: 'Voir le contenu',
        type: 'Blog et Média'
      }
    when 'le_tournedisque'
      {
        title: 'Le Tournedisque',
        description: 'Blog et podcast qui met en avant des pépites musicales françaises hors des radars',
        icon: '📝',
        color: 'from-yellow-400 to-red-500',
        link: 'https://www.letournedisque.com/',
        link_text: 'Voir le contenu',
        type: 'Blog et Média'
      }
    
    # Podcasts Exclusifs
    when 'underground_ivoire'
      {
        title: 'Underground Ivoire',
        description: 'Podcast dédié aux artistes émergents du rap ivoirien - Interviews, freestyles, coulisses',
        icon: '🎙️',
        color: 'from-red-400 to-pink-500',
        link: 'https://podcasts.apple.com/fr/podcast/underground-ivoire/id1690475959',
        link_text: 'Écouter le podcast',
        type: 'Podcast'
      }
    
    # Documentaires Exclusifs
    when 'didi_b_interview'
      {
        title: 'Interview Exclusive: Didi B',
        description: 'À cœur ouvert - Avant son concert au stade FHB, il se livre sur sa carrière et ses émotions',
        icon: '🎬',
        color: 'from-purple-400 to-indigo-500',
        link: 'https://www.youtube.com/watch?v=WEfUGQZGDrE',
        link_text: 'Regarder le documentaire',
        type: 'Documentaire'
      }
    when 'himra_legendes_urbaines'
      {
        title: 'Himra dans Légendes Urbaines',
        description: 'Portrait complet avec des moments forts de sa carrière - Tiken Jah Fakoly x SDM',
        icon: '🎬',
        color: 'from-blue-400 to-purple-500',
        link: 'https://www.youtube.com/watch?v=EDFgyWTYju8',
        link_text: 'Regarder le documentaire',
        type: 'Documentaire'
      }
    when 'zoh_cataleya_serge_dioman'
      {
        title: 'La Télé d\'Ici',
        description: 'Zoh Cataleya et Serge Dioman - Discussion sur son parcours et ses engagements',
        icon: '🎬',
        color: 'from-purple-400 to-blue-500',
        link: 'https://www.youtube.com/watch?v=K3I1WR1zhAQ',
        link_text: 'Regarder le documentaire',
        type: 'Documentaire'
      }
    when 'do_it_together'
      {
        title: 'Do It Together',
        description: 'Un tour du monde de la scène indé, avec des escales à Paris, Belgrade, Amsterdam',
        icon: '🎬',
        color: 'from-yellow-400 to-orange-500',
        link: 'https://sourdoreille.net/do-it-together-pose-la-question-quest-ce-que-la-musique-inde/',
        link_text: 'Voir le documentaire',
        type: 'Documentaire'
      }
    when 'rumble_indians'
      {
        title: 'RUMBLE – The Indians Who Rocked the World',
        description: 'Documentaire primé à Sundance qui révèle l\'influence oubliée des musiciens amérindiens',
        icon: '🎬',
        color: 'from-red-400 to-orange-500',
        link: 'https://www.unidivers.fr/rumble-rock-indiens-amerique/',
        link_text: 'Voir le documentaire',
        type: 'Documentaire'
      }
    when 'country_music_ken_burns'
      {
        title: 'Country Music – Une histoire populaire des États-Unis',
        description: 'Réalisé par Ken Burns, ce documentaire retrace l\'évolution du genre country à travers les décennies',
        icon: '🎬',
        color: 'from-yellow-400 to-purple-500',
        link: 'https://www.arte.tv/fr/videos/113630-009-A/country-music-une-histoire-populaire-des-etats-unis-9-9/',
        link_text: 'Voir le documentaire',
        type: 'Documentaire'
      }
    when 'rap_odyssees_france_tv'
      {
        title: 'Rap Odyssées – France TV',
        description: 'Portrait de quatre jeunes rappeurs bordelais en pleine ascension',
        icon: '🎬',
        color: 'from-blue-400 to-indigo-500',
        link: 'https://www.france.tv/documentaires/documentaires-art-et-culture/7125029-bordeaux-l-opera-autrement.html',
        link_text: 'Voir le documentaire',
        type: 'Documentaire'
      }
    
    # Sessions Studio
    when 'himra_number_one_live'
      {
        title: 'HIMRA - NUMBER ONE (Live Version)',
        description: 'Version live qui reflète l\'ambiance studio',
        icon: '🎹',
        color: 'from-purple-400 to-pink-500',
        link: 'https://www.youtube.com/watch?v=hn35k3R9Ja4',
        link_text: 'Regarder la session',
        type: 'Session Studio'
      }
    when 'didi_b_nouvelle_generation'
      {
        title: 'DIDI B EN STUDIO AVEC LA NOUVELLE GÉNÉRATION',
        description: 'Session studio avec Didi B et d\'autres artistes',
        icon: '🎹',
        color: 'from-orange-400 to-red-500',
        link: 'https://www.youtube.com/watch?v=9ECNWJ1R0fg',
        link_text: 'Regarder la session',
        type: 'Session Studio'
      }
    when 'zoh_cataleya_live_toura'
      {
        title: 'ZOH CATALEYA - LIVE TOURA DRILL 1',
        description: 'Performance live proche d\'une session studio',
        icon: '🎹',
        color: 'from-purple-400 to-blue-500',
        link: 'https://www.youtube.com/watch?v=e0sVW6DjgbU',
        link_text: 'Regarder la session',
        type: 'Session Studio'
      }
    when 'bigyne_wiz_abe_sounogola'
      {
        title: 'Séance studio Bigyne Wiz',
        description: 'Abé sounôgôla - Session studio disponible',
        icon: '🎹',
        color: 'from-yellow-400 to-orange-500',
        link: 'https://www.youtube.com/watch?v=_u7Fsg-knCE',
        link_text: 'Regarder la session',
        type: 'Session Studio'
      }
    when 'didi_b_mhd_studio'
      {
        title: 'Didi B au studio avec MHD',
        description: 'Extrait studio avec MHD - Une exclu en pétard',
        icon: '🎹',
        color: 'from-red-400 to-pink-500',
        link: 'https://www.youtube.com/watch?v=3-pLRfSb6oM',
        link_text: 'Regarder la session',
        type: 'Session Studio'
      }
    when 'didi_b_naira_marley'
      {
        title: 'DIDI B FEAT NAIRA MARLEY',
        description: 'Du nouveau hits - Séance studio exclusif',
        icon: '🎹',
        color: 'from-blue-400 to-purple-500',
        link: 'https://www.youtube.com/watch?v=d_Tt-DSDpiI',
        link_text: 'Regarder la session',
        type: 'Session Studio'
      }
    when 'didi_b_enregistrement'
      {
        title: 'VOICI COMMENT DIDI B ENREGISTRE SES SONG',
        description: 'Session studio générale incluant Rodela',
        icon: '🎹',
        color: 'from-purple-400 to-blue-500',
        link: 'https://www.youtube.com/watch?v=YCs4vMwOVwc',
        link_text: 'Regarder la session',
        type: 'Session Studio'
      }
    when 'werenoi_cstar_session'
      {
        title: 'Werenoi - CSTAR Session (live)',
        description: 'Location / Solitaire / Chemin d\'or - Session live',
        icon: '🎹',
        color: 'from-purple-400 to-indigo-500',
        link: 'https://www.youtube.com/watch?v=2Q-ZZG-SPvU',
        link_text: 'Regarder la session',
        type: 'Session Studio'
      }
    when 'himra_top_boy_live'
      {
        title: 'HIMRA - TOP BOY LIVE VERSION',
        description: 'Version live exclusive',
        icon: '🎹',
        color: 'from-orange-400 to-red-500',
        link: 'https://www.youtube.com/watch?v=NHqgPK7BlJk',
        link_text: 'Regarder la session',
        type: 'Session Studio'
      }
    when 'timar_zz_lequel'
      {
        title: 'Timar feat. ZZ - Lequel',
        description: 'EXCLU - Session studio exclusive',
        icon: '🎹',
        color: 'from-blue-400 to-purple-500',
        link: 'https://www.youtube.com/watch?v=umTlEIX0GFI',
        link_text: 'Regarder la session',
        type: 'Session Studio'
      }
    when 'octogone_philipayne'
      {
        title: 'OCTOGONE - PHILIPAYNE',
        description: 'Avec Enfant Noir, Le Couteau, Slai & BigGodzi',
        icon: '🎹',
        color: 'from-red-400 to-purple-500',
        link: 'https://www.youtube.com/watch?v=Fnez6Uc4J6o',
        link_text: 'Regarder la session',
        type: 'Session Studio'
      }
    else
      {
        title: 'Contenu Exclusif',
        description: 'Contenu exclusif à débloquer',
        icon: '⭐',
        color: 'from-gray-400 to-gray-600',
        link: nil,
        link_text: 'Contenu exclusif à débloquer',
        type: 'Exclusif'
      }
    end
  end
  
  def video_details
    @reward = current_user.rewards.find(params[:id])
    
    # Si c'est une récompense challenge, récupérer la playlist associée
    if @reward.content_type&.start_with?('challenge_reward_playlist')
      playlist_title = case @reward.content_type
                      when 'challenge_reward_playlist_1' then 'Challenge Reward Videos 1'
                      when 'challenge_reward_playlist_2' then 'Challenge Reward Videos 2'
                      when 'challenge_reward_playlist_3' then 'Challenge Reward Videos 3'
                      when 'challenge_reward_playlist_4' then 'Challenge Reward Videos 4'
                      when 'challenge_reward_playlist_5' then 'Challenge Reward Videos 5'
                      when 'challenge_reward_playlist_6' then 'Challenge Reward Videos 6'
                      when 'challenge_reward_playlist_7' then 'Challenge Reward Videos 7'
                      when 'challenge_reward_playlist_8' then 'Challenge Reward Videos 8'
                      when 'challenge_reward_playlist_9' then 'Challenge Reward Videos 9'
                      when 'challenge_reward_playlist_10' then 'Challenge Reward Videos 10'
                      when 'challenge_reward_playlist_11' then 'Challenge Reward Videos 11'
                      when 'challenge_reward_playlist_12' then 'Challenge Reward Videos 12'
                      when 'challenge_reward_playlist_13' then 'Challenge Reward Videos 13'
                      when 'challenge_reward_playlist_14' then 'Challenge Reward Videos 14'
                      when 'challenge_reward_playlist_15' then 'Challenge Reward Videos 15'
                      end
      
      @playlist = Playlist.find_by(title: playlist_title) if playlist_title
    end
    
    render 'video_details'
  end
  
  def reward_details
    # DEBUG: Afficher les paramètres reçus
    puts "DEBUG reward_details: params = #{params.inspect}"
    puts "DEBUG reward_details: badge_type = #{params[:badge_type]}"
    puts "DEBUG reward_details: quantity = #{params[:quantity]}"
    
    @badge_type = params[:badge_type] || 'unified'
    @quantity = (params[:quantity] || 0).to_i
    @category = 'unified'
    
    # DEBUG: Vérifier les valeurs
    puts "DEBUG: @badge_type = #{@badge_type.inspect}"
    puts "DEBUG: @quantity = #{@quantity.inspect}"
    puts "DEBUG: params[:quantity] = #{params[:quantity].inspect}"
    
    # Calculer la progression pour le système unifié
    @current_count = current_user.user_badges.count
    @progress = [(@current_count.to_f / @quantity * 100), 100].min
    
    # Générer les informations de la récompense
    @reward_type = case @quantity
                   when 3 then 'challenge'
                   when 6 then 'exclusif'
                   when 9 then 'premium'
                   when 12 then 'ultime'
                   end
    
    @reward_name = case @quantity
                   when 3 then '🎯 Challenge'
                   when 6 then '⭐ Exclusif'
                   when 9 then '👑 Premium'
                   when 12 then '🏆 Ultime'
                   end
    
    @reward_description = generate_reward_description(@badge_type, @quantity, @reward_type, @category)
    
    # Récupérer une récompense débloquée réelle pour afficher le contenu
    @sample_reward = current_user.rewards.where(reward_type: @reward_type, unlocked: true).first
    
    # Statistiques par niveau pour l'affichage
    @bronze_count = current_user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    @silver_count = current_user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    @gold_count = current_user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
    
    # Rendre explicitement la vue details
    render 'details'
  end

  # Action de test temporaire
  def test_details
    @badge_type = 'unified'
    @quantity = 3
    @category = 'unified'
    @current_count = current_user.user_badges.count
    @progress = [(@current_count.to_f / @quantity * 100), 100].min
    @reward_type = 'challenge'
    @reward_name = '🎯 Challenge'
    @reward_description = generate_reward_description(@badge_type, @quantity, @reward_type, @category)
    @sample_reward = current_user.rewards.where(reward_type: @reward_type, unlocked: true).first
    @bronze_count = current_user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    @silver_count = current_user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    @gold_count = current_user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
    render 'details'
  end
  
  def challenge
    # Récupérer les récompenses challenge débloquées
    @unlocked_challenge_rewards = current_user.rewards.where(reward_type: 'challenge', unlocked: true)
    
    # Récupérer les playlists challenge de l'utilisateur
    @challenge_playlists = current_user.challenge_playlists
    
    # Variables pour la progression et les statistiques
    @current_badge_count = current_user.user_badges.count
    @progress_percentage = [(@current_badge_count.to_f / 3 * 100), 100].min
    
    # Statistiques par niveau
    @bronze_count = current_user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    @silver_count = current_user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    @gold_count = current_user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
  end
  
  def unlock
    # Vérifier et créer les récompenses pour l'utilisateur avec notifications
    new_rewards = RewardNotificationService.check_and_notify_rewards(current_user)
    
    if new_rewards.any?
      redirect_to my_rewards_path, notice: "🎉 #{new_rewards.count} nouvelle(s) récompense(s) débloquée(s) !"
    else
      redirect_to my_rewards_path, notice: 'Récompenses vérifiées et mises à jour !'
    end
  end

  def exclusif
    # Page des récompenses exclusives (6 badges requis)
    @unlocked_exclusif_rewards = current_user.rewards.where(reward_type: 'exclusif', unlocked: true).order(created_at: :desc)
    
    # Statistiques des badges pour la progression
    @current_badge_count = current_user.user_badges.count
    @progress_percentage = [(@current_badge_count.to_f / 6 * 100), 100].min
    
    # Statistiques par niveau
    @bronze_count = current_user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    @silver_count = current_user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    @gold_count = current_user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
  end
  
  def partners
    # Page des partenaires et codes promo
    render 'partners'
  end
  
  private
  
  def generate_reward_description(badge_type, quantity, reward_type, category)
    case reward_type
    when 'challenge'
      "#{quantity} badges - Accès anticipé à des playlists + codes promo exclusifs"
    when 'exclusif'
      "#{quantity} badges - Photos dédicacées d'artistes + contenu exclusif"
    when 'premium'
      "#{quantity} badges - Rencontres avec des artistes + accès backstage virtuel"
    when 'ultime'
      "#{quantity} badges - Rencontre privée avec un artiste + accès backstage réel"
    end
  end
  
  def calculate_next_accessible_reward(user)
    badge_count = user.user_badges.count
    
    # Définir les niveaux de récompenses dans l'ordre
    reward_levels = [
      { level: 'challenge', quantity: 3, name: 'Challenge', icon: '🥉' },
      { level: 'exclusif', quantity: 6, name: 'Exclusif', icon: '🥈' },
      { level: 'premium', quantity: 9, name: 'Premium', icon: '🥇' },
      { level: 'ultime', quantity: 12, name: 'Ultime', icon: '🌈' }
    ]
    
    # Trouver la prochaine récompense accessible
    reward_levels.each do |reward_level|
      # Vérifier si l'utilisateur a déjà cette récompense
      existing_reward = user.rewards.where(reward_type: reward_level[:level], unlocked: true).first
      
      # Si la récompense n'existe pas et que l'utilisateur a assez de badges
      if !existing_reward && badge_count >= reward_level[:quantity]
        return {
          level: reward_level[:level],
          quantity: reward_level[:quantity],
          name: reward_level[:name],
          icon: reward_level[:icon],
          current_badges: badge_count,
          progress_percentage: [(badge_count.to_f / reward_level[:quantity] * 100), 100].min
        }
      end
    end
    
    # Si toutes les récompenses sont débloquées, retourner nil
    nil
  end
end 