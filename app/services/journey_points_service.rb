# Attribue les points du parcours (refonte gameplay) à chaque swipe.
# Règles : Like +5, Dislike +1, Vidéo regardée +2, Nouvel artiste +10, Bonus 10 vidéos/jour +20.
class JourneyPointsService
  POINTS_LIKE = 5
  POINTS_DISLIKE = 1
  POINTS_WATCH_END = 2
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

      # Vidéo regardée (jusqu’au swipe) = +2
      total += POINTS_WATCH_END
      breakdown[:watch] = POINTS_WATCH_END

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

      user.update_column(:journey_points, user.journey_points + total) if total > 0

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
