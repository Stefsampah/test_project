# Attribue les points du parcours (refonte gameplay) à chaque swipe.
# Règles : Like +2, Dislike +1, Vidéo regardée +1 (>= WATCH_SECONDS_MIN),
# Like sur nouvel artiste +2, bonus combo max +1.
class JourneyPointsService
  POINTS_LIKE = 2
  POINTS_DISLIKE = 1
  POINTS_WATCH_END = 1
  WATCH_SECONDS_MIN = 8
  POINTS_NEW_ARTIST = 2
  POINTS_DAILY_PLAYLIST_STREAK = 5
  POINTS_COMBO_TIER_1 = 1
  MAX_POINTS_PER_SWIPE = 20
  MAX_SWIPES_COUNTED_PER_GAME = 120
  MAX_SWIPES_COUNTED_PER_DAY = 400

  class << self
    # Appelé après création d’un swipe. Calcule et ajoute les points au user.journey_points.
    # Retourne un hash avec les points ajoutés (pour affichage éventuel en front).
    def add_swipe_points(user, swipe, video)
      # Garde-fous anti-extrême pour limiter les écarts de progression.
      return { total: 0, breakdown: { capped: "game_limit" } } if game_cap_reached?(swipe)
      return { total: 0, breakdown: { capped: "day_limit" } } if day_cap_reached?(user)

      total = 0
      breakdown = {}
      unlocks = []

      # Like = +2, Dislike = +1
      action_points = swipe.liked? ? POINTS_LIKE : POINTS_DISLIKE
      total += action_points
      breakdown[:action] = action_points

      # Bonus watch uniquement si un minimum de visionnage est atteint.
      if swipe.respond_to?(:watched_seconds) && swipe.watched_seconds.to_i >= WATCH_SECONDS_MIN
        total += POINTS_WATCH_END
        breakdown[:watch] = POINTS_WATCH_END
      end

      # Like sur nouvel artiste = +2 (premier like de l'utilisateur pour cet artiste)
      artist = video_artist(video)
      if swipe.liked? && artist.present? && first_like_for_artist?(user, artist, video.id)
        total += POINTS_NEW_ARTIST
        breakdown[:new_artist] = POINTS_NEW_ARTIST
      end

      combo_points = combo_bonus_points(swipe)
      if combo_points.positive?
        total += combo_points
        breakdown[:combo] = combo_points
      end

      # Boost VIP: +50% de points parcours
      if user.respond_to?(:vip?) && user.vip?
        total = (total * 1.5).round
        breakdown[:vip_boost] = "+50%"
      end

      if total > MAX_POINTS_PER_SWIPE
        total = MAX_POINTS_PER_SWIPE
        breakdown[:safety_cap] = MAX_POINTS_PER_SWIPE
      end

      return { total: 0, breakdown: {} } if total <= 0

      # Compteur principal unique: progression concert basée sur journey_points.
      new_journey_points = user.journey_points.to_i + total
      attrs = { journey_points: new_journey_points }

      # On garde season_journey_points synchronisé pour compatibilité d'affichage.
      attrs[:season_journey_points] = new_journey_points if user.respond_to?(:season_journey_points)

      # Palier 2 000 points: lien de concert
      if !user.season_concert_link_eligible && new_journey_points >= 2_000
        attrs[:season_concert_link_eligible] = true
        unlocks << "concert_link"
      end

      # Palier 4 500 points: éligible tirage place physique
      if !user.season_concert_ticket_eligible && new_journey_points >= 4_500
        attrs[:season_concert_ticket_eligible] = true
        unlocks << "concert_ticket"
      end

      user.update_columns(attrs)

      { total: total, breakdown: breakdown, unlocks: unlocks }
    end

    private

    def video_artist(video)
      video.respond_to?(:artist) && video.artist.present? ? video.artist.strip : nil
    end

    # True si c’est le premier like de l’user sur une vidéo de cet artiste
    def first_like_for_artist?(user, artist, _current_video_id)
      return false if artist.blank?
      video_ids_with_artist = Video.where("LOWER(TRIM(artist)) = ?", artist.to_s.downcase).pluck(:id)
      return false if video_ids_with_artist.empty?
      count = Swipe.joins(:game)
                   .where(games: { user_id: user.id })
                   .where(video_id: video_ids_with_artist, action: "like")
                   .count
      count == 1
    end

    def user_swipes_today_count(user)
      Swipe.joins(:game).where(games: { user_id: user.id })
           .where(swipes: { created_at: Time.current.all_day })
           .count
    end

    def combo_bonus_points(swipe)
      return 0 unless swipe.respond_to?(:game_id) && swipe.game_id.present?
      return 0 unless swipe.respond_to?(:watched_seconds) && swipe.watched_seconds.to_i >= WATCH_SECONDS_MIN

      sequence = Swipe.where(game_id: swipe.game_id).order(created_at: :desc).limit(8).to_a
      return 0 if sequence.empty?

      qualified_streak = 0
      sequence.each do |s|
        break unless s.watched_seconds.to_i >= WATCH_SECONDS_MIN

        qualified_streak += 1
      end

      return 0 if qualified_streak < 3
      return 0 if extreme_same_action_streak?(sequence)

      POINTS_COMBO_TIER_1
    end

    def extreme_same_action_streak?(sequence)
      actions = sequence.first(4).map(&:action)
      actions.length == 4 && actions.uniq.length == 1
    end

    def game_cap_reached?(swipe)
      return false unless swipe.respond_to?(:game_id) && swipe.game_id.present?

      Swipe.where(game_id: swipe.game_id).count > MAX_SWIPES_COUNTED_PER_GAME
    end

    def day_cap_reached?(user)
      user_swipes_today_count(user) > MAX_SWIPES_COUNTED_PER_DAY
    end
  end
end
