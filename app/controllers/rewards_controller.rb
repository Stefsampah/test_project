class RewardsController < ApplicationController
  before_action :authenticate_user!
  helper_method :get_audio_comment_video_id
  
  def index
    redirect_to my_rewards_path
  end
  
  def my_rewards
    @rewards = current_user.rewards.where(unlocked: true).order(created_at: :desc)
    @unlocked_rewards = @rewards
    
    @challenge_rewards = @rewards.where(reward_type: 'challenge')
    @exclusif_rewards = @rewards.where(reward_type: 'exclusif')
    @premium_rewards = @rewards.where(reward_type: 'premium')
    @ultime_rewards = @rewards.where(reward_type: 'ultime')
    
    @next_accessible_reward = calculate_next_accessible_reward(current_user)
    
    @badge_counts = {}
    Badge.distinct.pluck(:badge_type).each do |badge_type|
      @badge_counts[badge_type] = current_user.user_badges.joins(:badge).where(badges: { badge_type: badge_type }).count
    end
    
    @progress = current_user.progress_to_next_digital_reward
    @next_level = current_user.next_digital_reward_level
    
    # Récupérer les images aléatoires pour les récompenses premium
    @premium_reward_images = get_premium_reward_images
    
    # Récupérer les images pour les récompenses ultimes
    @ultime_reward_images = get_ultime_reward_images
  end
  
  def all_rewards
    @user_rewards = current_user.rewards.order(:badge_type, :quantity_required)
    @rewards_by_type = @user_rewards.group_by(&:badge_type)
    
    @badge_counts = {}
    Badge.distinct.pluck(:badge_type).each do |badge_type|
      @badge_counts[badge_type] = current_user.user_badges.joins(:badge).where(badges: { badge_type: badge_type }).count
    end
    
    @total_rewards = Reward.count
    @unlocked_rewards = Reward.unlocked.count
    @locked_rewards = Reward.where(unlocked: false).count
  end
  
  def show
    @reward = current_user.rewards.find(params[:id])
    
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
    
    if @reward.reward_type == 'exclusif'
      @exclusif_content = get_exclusif_content_details(@reward.content_type)
    elsif @reward.reward_type == 'premium'
      @premium_content = get_premium_content_details(@reward.content_type)
    end
  end
  
  def reward_details
    # Vérifier s'il s'agit d'un NFT spécifique
    @content_type = params[:content_type]
    
    puts "🔍 DEBUG reward_details: content_type=#{@content_type}"
    
    if @content_type && @content_type.end_with?('_nft')
      # Mode NFT spécifique
      puts "✅ NFT détecté: #{@content_type}"
      @nft_data = get_nft_data(@content_type)
      @artist_name = @nft_data[:artist_name]
      @artist_description = @nft_data[:artist_description]
      @gradient_colors = @nft_data[:gradient_colors]
      
      puts "🎨 NFT Data: #{@nft_data}"
      
      render 'nft_details'
      return
    end
    
    # Mode récompense normale
    @badge_type = params[:badge_type] || 'unified'
    @quantity = (params[:quantity] || 0).to_i
    @category = 'unified'
    
    @current_count = current_user.user_badges.count
    @progress = [(@current_count.to_f / @quantity * 100), 100].min
    Rails.logger.info "🔍 DEBUG reward_details: @current_count=#{@current_count}, @quantity=#{@quantity}, condition=#{@current_count >= @quantity}"
    
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
    
    @sample_reward = current_user.rewards.where(reward_type: @reward_type, unlocked: true).first
    Rails.logger.info "🔍 DEBUG reward_details: @reward_type=#{@reward_type}, @sample_reward=#{@sample_reward&.content_type}"
    
    @bronze_count = current_user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    @silver_count = current_user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    @gold_count = current_user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
    
    render 'details'
  end
  
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
    @unlocked_challenge_rewards = current_user.rewards.where(reward_type: 'challenge', unlocked: true)
    @challenge_playlists = current_user.challenge_playlists
    
    @current_badge_count = current_user.user_badges.count
    @progress_percentage = [(@current_badge_count.to_f / 3 * 100), 100].min
    
    @bronze_count = current_user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    @silver_count = current_user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    @gold_count = current_user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
  end
  
  def unlock
    new_rewards = RewardNotificationService.check_and_notify_rewards(current_user)
    
    if new_rewards.any?
      redirect_to my_rewards_path, notice: "🎉 #{new_rewards.count} nouvelle(s) récompense(s) débloquée(s) !"
    else
      redirect_to my_rewards_path, notice: 'Récompenses vérifiées et mises à jour !'
    end
  end

  def exclusif
    @unlocked_exclusif_rewards = current_user.rewards.where(reward_type: 'exclusif', unlocked: true).order(created_at: :desc)
    
    @current_badge_count = current_user.user_badges.count
    @progress_percentage = [(@current_badge_count.to_f / 6 * 100), 100].min
    
    @bronze_count = current_user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    @silver_count = current_user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    @gold_count = current_user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
  end
  
  def partners
    render 'partners'
  end
  

  def exclusif_content
    @reward = current_user.rewards.find(params[:id])
    
    # Vérifier que l'utilisateur a accès à ce contenu exclusif
    unless @reward.unlocked && @reward.reward_type == 'exclusif'
      redirect_to my_rewards_path, alert: 'Vous n\'avez pas accès à ce contenu exclusif.'
      return
    end
    
    # Récupérer les détails du contenu exclusif
    @exclusif_content = get_exclusif_content_details(@reward.content_type)
    
    render 'exclusif_content'
  end



  private
  
  def get_exclusif_content_details(content_type)
    case content_type
    when 'didi_b_nouvelle_generation'
      {
        title: 'DIDI B EN STUDIO AVEC LA NOUVELLE GÉNÉRATION',
        description: 'Session studio avec Didi B et d\'autres artistes',
        icon: '🎹',
        color: 'from-purple-400 to-pink-500',
        link: 'https://www.youtube.com/watch?v=9ECNWJ1R0fg',
        link_text: 'Regarder la session',
        type: 'Session Studio',
        video_id: '9ECNWJ1R0fg'
      }
    when 'didi_b_interview'
      {
        title: 'DIDI B - INTERVIEW EXCLUSIVE',
        description: 'Interview exclusive avec Didi B sur sa carrière',
        icon: '🎙️',
        color: 'from-blue-400 to-purple-500',
        link: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        link_text: 'Écouter l\'interview',
        type: 'Interview Exclusive',
        video_id: 'dQw4w9WgXcQ'
      }
    when 'himra_legendes_urbaines'
      {
        title: 'HIMRA - LÉGENDES URBAINES',
        description: 'Performance live de Himra en concert',
        icon: '🎤',
        color: 'from-red-400 to-pink-500',
        link: 'https://www.youtube.com/watch?v=qB7kLilZWwg',
        link_text: 'Regarder le live',
        type: 'Live Performance',
        video_id: 'qB7kLilZWwg'
      }
    else
      {
        title: 'Contenu Exclusif',
        description: 'Contenu exclusif à découvrir',
        icon: '⭐',
        color: 'from-blue-400 to-purple-500',
        link: '#',
        link_text: 'Voir le contenu',
        type: 'Contenu Exclusif',
        video_id: nil
      }
    end
  end

  def get_premium_content_details(content_type)
    case content_type
    # Backstage exclusifs
    when 'charles_dore_backstage'
      {
        title: 'CHARLES DORÉ - SESSION ACOUSTIQUE EXCLUSIVE',
        description: 'Session acoustique intimiste qui dévoile les émotions derrière "Je pars mais je reste"',
        icon: '🎸',
        color: 'from-orange-400 to-red-500',
        link: 'https://www.youtube.com/watch?v=JWrIfPCyedU',
        link_text: 'Regarder la session acoustique',
        type: 'Backstage Acoustique',
        video_id: 'JWrIfPCyedU'
      }
    when 'carbonne_backstage'
      {
        title: 'CARBONNE - BACKSTAGE FESTIVAL',
        description: 'Backstage festival avec ambiance détendue et version alternative de "Falbala"',
        icon: '🎪',
        color: 'from-green-400 to-blue-500',
        link: 'https://www.tiktok.com/@dubsilence/video/7374726614250278177',
        link_text: 'Voir le backstage',
        type: 'Backstage Festival',
        video_id: nil
      }
    when 'fredz_backstage'
      {
        title: 'FREDZ - SOIRÉE VIP EN COULISSES',
        description: 'Soirée VIP en coulisses avec Fredz, émotions et confidences sur "Extraordinaire"',
        icon: '🌟',
        color: 'from-purple-400 to-pink-500',
        link: 'https://www.tiktok.com/@fredz_musicc/video/7520325137250503941',
        link_text: 'Voir la soirée VIP',
        type: 'Backstage VIP',
        video_id: nil
      }
    when 'adele_robin_backstage'
      {
        title: 'ADÈLE & ROBIN - BACKSTAGE COMPLICE',
        description: 'Backstage musical avec Adèle & Robin en mode complice sur "Avec toi"',
        icon: '🎭',
        color: 'from-blue-400 to-purple-500',
        link: 'https://www.tiktok.com/@adeleetrobin/video/7497310969584946454',
        link_text: 'Voir le backstage',
        type: 'Backstage Musical',
        video_id: nil
      }
    when 'victorien_backstage'
      {
        title: 'VICTORIEN - MOMENTS BACKSTAGE PARIS',
        description: 'Moments backstage et scène au Café de la Danse sur "Danse dans Paris"',
        icon: '🗼',
        color: 'from-yellow-400 to-orange-500',
        link: 'https://www.tiktok.com/@emiliebault/video/7515687097903222038',
        link_text: 'Voir le backstage Paris',
        type: 'Backstage Paris',
        video_id: nil
      }
    when 'miki_backstage'
      {
        title: 'MIKI - LIVE ACCOR ARENA',
        description: 'Performance live avec ambiance immersive de "Particule" à l\'Accor Arena',
        icon: '🎤',
        color: 'from-red-400 to-pink-500',
        link: 'https://www.youtube.com/watch?v=ICvSOFEKbgs',
        link_text: 'Regarder le live',
        type: 'Live Arena',
        video_id: 'ICvSOFEKbgs'
      }
    when 'marguerite_backstage'
      {
        title: 'MARGUERITE - VERSION LIVE ENGAGÉE',
        description: 'Version live avec émotions et engagement sur "Les filles, les meufs"',
        icon: '🎭',
        color: 'from-pink-400 to-purple-500',
        link: 'https://www.dailymotion.com/video/x9jtr7c',
        link_text: 'Voir la version live',
        type: 'Live Engagé',
        video_id: nil
      }
    when 'timeo_backstage'
      {
        title: 'TIMEO - CLIP COMPLET AVEC STORYTELLING',
        description: 'Clip complet avec scènes de tournage et storytelling de "Si je m\'en vais"',
        icon: '🎬',
        color: 'from-blue-400 to-green-500',
        link: 'https://www.youtube.com/watch?v=ORfP-QudA1A',
        link_text: 'Regarder le clip',
        type: 'Clip Officiel',
        video_id: 'ORfP-QudA1A'
      }
    when 'marine_backstage'
      {
        title: 'MARINE - CLIP COMPLET AMBIANCE VISUELLE',
        description: 'Clip complet avec ambiance visuelle et émotionnelle de "Cœur maladroit"',
        icon: '💝',
        color: 'from-pink-400 to-red-500',
        link: 'https://www.youtube.com/watch?v=VFvDwn2r5RI',
        link_text: 'Regarder le clip',
        type: 'Clip Officiel',
        video_id: 'VFvDwn2r5RI'
      }
    
    # Documentaires
    when 'oasis_supersonic'
      {
        title: 'OASIS: SUPERSONIC - DOCUMENTAIRE COMPLET',
        description: 'Retour sur le parcours du dernier groupe de rock superstar, amené au sommet et anéanti par ses fondateurs',
        icon: '🎸',
        color: 'from-yellow-400 to-orange-500',
        link: 'https://www.youtube.com/watch?v=lx-0uom3Tbk',
        link_text: 'Regarder le documentaire',
        type: 'Documentaire Rock',
        video_id: 'lx-0uom3Tbk'
      }
    when 'dj_mehdi_made_in_france'
      {
        title: 'DJ MEHDI : MADE IN FRANCE - LES ENFANTS DU RAP',
        description: 'Quand DJ Mehdi rencontre Kery James, le son d\'une chambre d\'ado devient l\'avant-garde du hip-hop français',
        icon: '🎧',
        color: 'from-blue-400 to-purple-500',
        link: 'https://www.youtube.com/watch?v=6TNCoRqzjvQ',
        link_text: 'Regarder le documentaire',
        type: 'Documentaire Rap',
        video_id: '6TNCoRqzjvQ'
      }
    when 'rap_francais_techno'
      {
        title: 'L\'AVENIR DU RAP FRANÇAIS EST-IL DANS LA TECHNO HARDCORE ?',
        description: 'Ou l\'inverse ? Enquête sur l\'évolution du rap français et ses influences techno',
        icon: '⚡',
        color: 'from-purple-400 to-pink-500',
        link: 'https://www.youtube.com/watch?v=MSsUrSnURSI&t=1330s',
        link_text: 'Regarder l\'enquête',
        type: 'Documentaire Techno',
        video_id: 'MSsUrSnURSI'
      }
    when 'madness_prince_du_ska'
      {
        title: 'MADNESS - PRINCE DU SKA, ROI DE LA POP',
        description: 'Cuivres éclatants, rythmes bondissants, synthétiseurs fous : retour sur la déferlante britannique Madness',
        icon: '🎺',
        color: 'from-green-400 to-blue-500',
        link: 'https://www.youtube.com/watch?v=qqNfk_xR1I0',
        link_text: 'Regarder le documentaire',
        type: 'Documentaire Ska',
        video_id: 'qqNfk_xR1I0'
      }
    when 'paname_grand_paris_rap'
      {
        title: 'PANAME, LE GRAND PARIS DU RAP - DOCUMENTAIRE COMPLET',
        description: 'Et si le rap avait été la première manifestation du Grand Paris ? Retour sur une décennie hors normes',
        icon: '🗼',
        color: 'from-blue-400 to-purple-500',
        link: 'https://www.youtube.com/watch?v=vCjo4saMVMg',
        link_text: 'Regarder le documentaire',
        type: 'Documentaire Paris',
        video_id: 'vCjo4saMVMg'
      }
    when 'gims_face_a_face'
      {
        title: 'LE FACE À FACE DE GIMS : LES SECRETS DE SA LONGÉVITÉ',
        description: 'Secrets de longévité, Booba, Sexion d\'Assaut - l\'histoire complète du rap français',
        icon: '🎤',
        color: 'from-red-400 to-orange-500',
        link: 'https://www.youtube.com/watch?v=IwEs-1Uyhx4',
        link_text: 'Regarder le face à face',
        type: 'Documentaire Gims',
        video_id: 'IwEs-1Uyhx4'
      }
    when 'afrobeats_phenomene'
      {
        title: 'AFROBEATS : LE PHÉNOMÈNE MUSICAL QUI SECOUE LE MONDE',
        description: 'Comment expliquer que ce son né au Nigéria ait réussi à conquérir le monde en à peine dix ans ?',
        icon: '🌍',
        color: 'from-green-400 to-yellow-500',
        link: 'https://www.youtube.com/watch?v=FhKwzAY_S_g',
        link_text: 'Regarder le documentaire',
        type: 'Documentaire Afrobeats',
        video_id: 'FhKwzAY_S_g'
      }
    when 'taylor_swift_phenomene'
      {
        title: 'LE PHÉNOMÈNE TAYLOR SWIFT – ENVOYÉ SPÉCIAL',
        description: 'Elle est devenue la plus grande star de la planète ! Enquête sur ce phénomène qui dépasse la musique',
        icon: '👑',
        color: 'from-pink-400 to-purple-500',
        link: 'https://www.youtube.com/watch?v=5d0HmGOgQ3M',
        link_text: 'Regarder le reportage',
        type: 'Reportage Swift',
        video_id: '5d0HmGOgQ3M'
      }
    when 'billie_eilish_world_blurry'
      {
        title: 'BILLIE EILISH: THE WORLD\'S A LITTLE BLURRY',
        description: 'Documentaire musical sur Billie Eilish, le plus beau documentaire de musique jamais vu',
        icon: '🎵',
        color: 'from-blue-400 to-green-500',
        link: 'https://www.youtube.com/watch?v=lx-0uom3Tbk',
        link_text: 'Regarder le documentaire',
        type: 'Documentaire Billie',
        video_id: 'lx-0uom3Tbk'
      }
    
    # Photos exclusives NFT
    when 'didi_b_nft'
      {
        title: 'DIDI B - PHOTO EXCLUSIVE NFT',
        description: 'Rapper, songwriter, performer, entrepreneur, Afro-urban visionary, leader of Africa Mindset',
        icon: '🖼️',
        color: 'from-purple-400 to-pink-500',
        link: '#',
        link_text: 'Voir la photo NFT',
        type: 'Photo NFT',
        video_id: nil
      }
    when 'okenneth_nft'
      {
        title: 'O\'KENNETH - PHOTO EXCLUSIVE NFT',
        description: 'Ghanaian rapper, raw voice of Kumasi, Asakaa drill pioneer, "Yimaye" – street soul meets introspection',
        icon: '🖼️',
        color: 'from-green-400 to-blue-500',
        link: '#',
        link_text: 'Voir la photo NFT',
        type: 'Photo NFT',
        video_id: nil
      }
    when 'chuwi_nft'
      {
        title: 'CHUWI - PHOTO EXCLUSIVE NFT',
        description: 'Indie tropical band from Isabela, Puerto Rico, "Weltita" (2025) – collab with Bad Bunny',
        icon: '🖼️',
        color: 'from-orange-400 to-red-500',
        link: '#',
        link_text: 'Voir la photo NFT',
        type: 'Photo NFT',
        video_id: nil
      }
    when 'punk_duo_nft'
      {
        title: 'PUNK DUO - PHOTO EXCLUSIVE NFT',
        description: 'Punk duo from Brighton, UK, queer, neurodivergent, loud & unapologetic',
        icon: '🖼️',
        color: 'from-red-400 to-purple-500',
        link: '#',
        link_text: 'Voir la photo NFT',
        type: 'Photo NFT',
        video_id: nil
      }
    when 'koffee_nft'
      {
        title: 'KOFFEE - PHOTO EXCLUSIVE NFT',
        description: 'KOFFEE #1 Reggae artist from Spanish Town, empowering, radiant, and unapologetically uplifting',
        icon: '🖼️',
        color: 'from-yellow-400 to-green-500',
        link: '#',
        link_text: 'Voir la photo NFT',
        type: 'Photo NFT',
        video_id: nil
      }
    
    else
      {
        title: 'Contenu Premium Exclusif',
        description: 'Contenu premium exclusif à découvrir',
        icon: '👑',
        color: 'from-orange-400 to-red-500',
        link: '#',
        link_text: 'Voir le contenu',
        type: 'Contenu Premium',
        video_id: nil
      }
    end
  end
  
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
    
    reward_levels = [
      { level: 'challenge', quantity: 3, name: 'Challenge', icon: '🥉' },
      { level: 'exclusif', quantity: 6, name: 'Exclusif', icon: '🥈' },
      { level: 'premium', quantity: 9, name: 'Premium', icon: '🥇' },
      { level: 'ultime', quantity: 12, name: 'Ultime', icon: '🌈' }
    ]
    
    reward_levels.each do |reward_level|
      existing_reward = user.rewards.where(reward_type: reward_level[:level], unlocked: true).first
      
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
    
    nil
  end

  # Nouvelle méthode pour obtenir des images aléatoires pour les récompenses premium
  def get_premium_reward_images
    premium_rewards = current_user.rewards.where(reward_type: 'premium', unlocked: true)
    images = {}
    
    premium_rewards.each do |reward|
      case reward.content_type
      when 'exclusive_photos'
        # Images aléatoires pour les photos exclusives
        available_images = [
          'https://img.youtube.com/vi/0tJz8JjPbHU/maxresdefault.jpg', # Didi B
          'https://img.youtube.com/vi/QVvfSQP3JLM/maxresdefault.jpg', # Didi B Bouaké
          'https://img.youtube.com/vi/JWrIfPCyedU/maxresdefault.jpg', # Charles Doré
          'https://img.youtube.com/vi/ICvSOFEKbgs/maxresdefault.jpg', # Miki
          'https://img.youtube.com/vi/ORfP-QudA1A/maxresdefault.jpg', # Timeo
          'https://img.youtube.com/vi/VFvDwn2r5RI/maxresdefault.jpg'  # Marine
        ]
        images[reward.id] = available_images.sample
      when 'backstage_video'
        # Images aléatoires pour les vidéos backstage
        available_images = [
          'https://img.youtube.com/vi/0tJz8JjPbHU/maxresdefault.jpg', # Didi B Félicia
          'https://img.youtube.com/vi/QVvfSQP3JLM/maxresdefault.jpg', # Didi B Bouaké
          'https://img.youtube.com/vi/JWrIfPCyedU/maxresdefault.jpg', # Charles Doré
          'https://img.youtube.com/vi/ICvSOFEKbgs/maxresdefault.jpg', # Miki Accor Arena
          'https://img.youtube.com/vi/ORfP-QudA1A/maxresdefault.jpg', # Timeo
          'https://img.youtube.com/vi/VFvDwn2r5RI/maxresdefault.jpg'  # Marine
        ]
        images[reward.id] = available_images.sample
      when 'concert_footage'
        # Images aléatoires pour les extraits de concert
        available_images = [
          'https://img.youtube.com/vi/0tJz8JjPbHU/maxresdefault.jpg', # Didi B
          'https://img.youtube.com/vi/QVvfSQP3JLM/maxresdefault.jpg', # Didi B
          'https://img.youtube.com/vi/ICvSOFEKbgs/maxresdefault.jpg', # Miki
          'https://img.youtube.com/vi/ORfP-QudA1A/maxresdefault.jpg', # Timeo
          'https://img.youtube.com/vi/VFvDwn2r5RI/maxresdefault.jpg'  # Marine
        ]
        images[reward.id] = available_images.sample
      else
        # Images par défaut pour les autres types de contenu premium
        default_images = [
          'https://img.youtube.com/vi/0tJz8JjPbHU/maxresdefault.jpg', # Didi B
          'https://img.youtube.com/vi/QVvfSQP3JLM/maxresdefault.jpg', # Didi B
          'https://img.youtube.com/vi/JWrIfPCyedU/maxresdefault.jpg', # Charles Doré
          'https://img.youtube.com/vi/ICvSOFEKbgs/maxresdefault.jpg', # Miki
          'https://img.youtube.com/vi/ORfP-QudA1A/maxresdefault.jpg', # Timeo
          'https://img.youtube.com/vi/VFvDwn2r5RI/maxresdefault.jpg'  # Marine
        ]
        images[reward.id] = default_images.sample
      end
    end
    
    images
  end
  
  # Nouvelle méthode pour obtenir des images pour les récompenses ultimes
  def get_ultime_reward_images
    ultime_rewards = current_user.rewards.where(reward_type: 'ultime', unlocked: true)
    images = {}
    
    ultime_rewards.each do |reward|
      case reward.content_type
      when 'backstage_real'
        # Images pour l'expérience backstage réelle
        available_images = [
          '/assets/images/rewards/ultime/backstage_real/backstage_concert_1.jpg',
          '/assets/images/rewards/ultime/backstage_real/backstage_concert_2.jpg',
          '/assets/images/rewards/ultime/backstage_real/backstage_concert_3.jpg',
          '/assets/images/rewards/ultime/backstage_real/backstage_concert_4.jpg'
        ]
        images[reward.id] = available_images.sample
      when 'concert_invitation'
        # Images pour l'invitation au concert
        available_images = [
          '/assets/images/rewards/ultime/concert_invitation/concert_stage_1.jpg',
          '/assets/images/rewards/ultime/concert_invitation/concert_stage_2.jpg',
          '/assets/images/rewards/ultime/concert_invitation/concert_stage_3.jpg',
          '/assets/images/rewards/ultime/concert_invitation/concert_stage_4.jpg'
        ]
        images[reward.id] = available_images.sample
      when 'vip_experience'
        # Images pour l'expérience VIP
        available_images = [
          '/assets/images/rewards/ultime/vip_experience/vip_meeting_1.jpg',
          '/assets/images/rewards/ultime/vip_experience/vip_meeting_2.jpg',
          '/assets/images/rewards/ultime/vip_experience/vip_meeting_3.jpg',
          '/assets/images/rewards/ultime/vip_experience/vip_meeting_4.jpg'
        ]
        images[reward.id] = available_images.sample
      else
        # Image par défaut pour les autres types
        images[reward.id] = '/assets/images/rewards/ultime/default_ultime.jpg'
      end
    end
    
    images
  end
  
  # Méthode pour obtenir les données NFT spécifiques
  def get_nft_data(content_type)
    case content_type
    when 'didi_b_nft'
      {
        artist_name: 'DIDI B',
        artist_description: 'Rapper, songwriter, performer, entrepreneur, Afro-urban visionary, leader of Africa Mindset',
        gradient_colors: 'from-blue-500 to-purple-600'
      }
    when 'okenneth_nft'
      {
        artist_name: 'O\'KENNETH',
        artist_description: 'Ghanaian rapper, raw voice of Kumasi, Asakaa drill pioneer, \'Yimaye\' – street soul meets introspection',
        gradient_colors: 'from-green-400 to-blue-500'
      }
    when 'chuwi_nft'
      {
        artist_name: 'CHUWI',
        artist_description: 'Indie tropical band from Isabela, Puerto Rico, \'Weltita\' (2025) – collab with Bad Bunny',
        gradient_colors: 'from-orange-400 to-red-500'
      }
    when 'punk_duo_nft'
      {
        artist_name: 'PUNK DUO',
        artist_description: 'Punk duo from Brighton, UK, queer, neurodivergent, loud & unapologetic',
        embed_id: '4M9VUTjC7s3nhCshh6DxoR',
        gradient_colors: 'from-red-400 to-purple-500'
      }
    when 'koffee_nft'
      {
        artist_name: 'KOFFEE',
        artist_description: 'Reggae artist from Spanish Town, empowering, radiant, and unapologetically uplifting',
        gradient_colors: 'from-yellow-400 to-green-500'
      }
    else
      {
        artist_name: 'ARTIST',
        artist_description: 'Musical artist NFT collection',
        embed_id: '4M9VUTjC7s3nhCshh6DxoR',
        gradient_colors: 'from-purple-400 to-pink-500'
      }
    end
  end

  # Helper method pour obtenir un ID vidéo aléatoire pour audio_comments
  public
  def get_audio_comment_video_id
    audio_comment_videos = [
      'AWlwxYU9xc8', # Chappell Roan - The Subway
      'QGjSPYPnd6w', # Lewis Capaldi
      'xHgnQEfi-5U', # KATSEYE
      '0zCfmYkDXR0', # JADE
      'xLZTw5cLgM8', # Leigh-Anne
      'm5Z5i0W9Kfc', # Say Now
      'DP4inRFySSQ', # Glass Animals
      'pbkHA3Kww28', # FKA twigs
      'Itc585kiAUk'  # Elle Coves - Peace (TikTok ID utilisé comme fallback)
    ]
    
    selected_video = audio_comment_videos.sample
    Rails.logger.info "🎧 Audio comment video selected: #{selected_video}"
    selected_video
  end
end 