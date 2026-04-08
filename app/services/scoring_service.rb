class ScoringService
  LIKE_POINTS = 2
  DISLIKE_POINTS = 1
  EXTREME_RATIO_THRESHOLD = 0.90
  EXTREME_RATIO_MALUS = 0.85

  class << self
    def register_playlist_score!(user:, playlist:, game:, apply_anti_abuse: false)
      score = Score.find_or_initialize_by(user: user, playlist: playlist)
      points = apply_anti_abuse ? final_game_score(game) : raw_game_score(game)
      score.points = points
      score.save!
      score
    end

    def raw_game_score(game)
      likes = game.swipes.where(action: "like").count
      dislikes = game.swipes.where(action: "dislike").count
      (likes * LIKE_POINTS) + (dislikes * DISLIKE_POINTS)
    end

    def final_game_score(game)
      base = raw_game_score(game)
      (base * anti_abuse_multiplier(game)).round
    end

    def anti_abuse_multiplier(game)
      like_count = game.swipes.where(action: "like").count
      dislike_count = game.swipes.where(action: "dislike").count
      total = like_count + dislike_count
      return 1.0 if total < 6

      like_ratio = like_count.to_f / total
      dislike_ratio = dislike_count.to_f / total

      if like_ratio >= EXTREME_RATIO_THRESHOLD || dislike_ratio >= EXTREME_RATIO_THRESHOLD
        EXTREME_RATIO_MALUS
      else
        1.0
      end
    end
  end
end
