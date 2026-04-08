# Attribue les points du parcours (refonte gameplay) à chaque swipe.
# Règles : Like +5, Dislike +1, Vidéo regardée +2, Nouvel artiste +10, Bonus 10 vidéos/jour +20.
class JourneyPointsService
  POINTS_LIKE = 5
  POINTS_DISLIKE = 1
  POINTS_WATCH_END = 2
  WATCH_SECONDS_MIN = 8
  POINTS_NEW_ARTIST = 10
  POINTS_DAILY_BONUS = 20
  DAILY_VIDEOS_FOR_BONUS = 10

  class << self
    # Appelé après création d’un swipe. Calcule et ajoute les points au user.journey_points.
    # Retourne un hash avec les points ajoutés (pour affichage éventuel en front).
    def add_swipe_points(user, swipe, video)
      total = 0
      breakdown = {}

      # Like = +5, Dislike = +1
      action_points = swipe.liked? ? POINTS_LIKE : POINTS_DISLIKE
      total += action_points
      breakdown[:action] = action_points

      # Bonus watch uniquement si un minimum de visionnage est atteint.
      if swipe.respond_to?(:watched_seconds) && swipe.watched_seconds.to_i >= WATCH_SECONDS_MIN
        total += POINTS_WATCH_END
        breakdown[:watch] = POINTS_WATCH_END
      end

      # Nouvel artiste = +10 (première fois que l’user swipe une vidéo de cet artiste)
      artist = video_artist(video)
      if artist.present? && first_swipe_for_artist?(user, artist, video.id)
        total += POINTS_NEW_ARTIST
        breakdown[:new_artist] = POINTS_NEW_ARTIST
      end

      # Bonus quotidien : tous les 10 vidéos dans la journée = +20
      swipes_today = user_swipes_today_count(user)
      if (swipes_today % DAILY_VIDEOS_FOR_BONUS) == 0 && swipes_today > 0
        total += POINTS_DAILY_BONUS
        breakdown[:daily_bonus] = POINTS_DAILY_BONUS
      end

      # Boost VIP: +50% de points parcours
      if user.respond_to?(:vip?) && user.vip?
        total = (total * 1.5).round
        breakdown[:vip_boost] = "+50%"
      end

      return { total: 0, breakdown: {} } if total <= 0

      # Mise à jour des points parcours globaux
      user.update_column(:journey_points, user.journey_points.to_i + total)

      # Mise à jour des points de saison si une saison courante existe
      season = Season.current rescue nil
      if season && user.respond_to?(:season_journey_points)
        new_season_points = user.season_journey_points.to_i + total

        attrs = {
          season_journey_points: new_season_points
        }

        # Palier 3 000 points: lien de concert
        if !user.season_concert_link_eligible && new_season_points >= 3_000
          attrs[:season_concert_link_eligible] = true
        end

        # Palier 6 000 points: éligible tirage place physique
        if !user.season_concert_ticket_eligible && new_season_points >= 6_000
          attrs[:season_concert_ticket_eligible] = true
        end

        user.update_columns(attrs)
      end

      { total: total, breakdown: breakdown }
    end

    private

    def video_artist(video)
      video.respond_to?(:artist) && video.artist.present? ? video.artist.strip : nil
    end

    # True si c’est le premier swipe de l’user sur une vidéo de cet artiste (le swipe actuel vient d’être créé)
    def first_swipe_for_artist?(user, artist, _current_video_id)
      return false if artist.blank?
      video_ids_with_artist = Video.where("LOWER(TRIM(artist)) = ?", artist.to_s.downcase).pluck(:id)
      return false if video_ids_with_artist.empty?
      count = Swipe.joins(:game).where(games: { user_id: user.id }).where(video_id: video_ids_with_artist).count
      count == 1
    end

    def user_swipes_today_count(user)
      Swipe.joins(:game).where(games: { user_id: user.id })
           .where(swipes: { created_at: Time.current.all_day })
           .count
    end
  end
end
