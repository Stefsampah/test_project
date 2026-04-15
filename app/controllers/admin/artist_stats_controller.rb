module Admin
  class ArtistStatsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin!

    def index
      @current_window = 7.days.ago..Time.current
      previous_window = 14.days.ago...7.days.ago

      current_rank_by_artist = rank_by_artist_for(@current_window)
      previous_rank_by_artist = rank_by_artist_for(previous_window)
      top_playlist_by_artist = top_playlist_by_artist_for(@current_window)

      @artist_rows = artist_rows_for(@current_window).map do |row|
        artist_name = row.artist_name
        current_rank = current_rank_by_artist[artist_name]
        previous_rank = previous_rank_by_artist[artist_name]

        rank_delta =
          if previous_rank.nil? || current_rank.nil?
            nil
          else
            previous_rank - current_rank
          end

        {
          artist_name: artist_name,
          discovered_fans_count: row.discovered_fans_count.to_i,
          likes_count: row.likes_count.to_i,
          total_listens: row.total_listens.to_i,
          playlist_plays_count: row.playlist_plays_count.to_i,
          playlists_count: row.playlists_count.to_i,
          current_rank: current_rank,
          rank_delta: rank_delta,
          top_playlist: top_playlist_by_artist[artist_name]
        }
      end

      @artist_rows.sort_by! { |entry| [-entry[:likes_count], -entry[:total_listens]] }
    end

    private

    def ensure_admin!
      return if current_user&.admin?

      redirect_to root_path, alert: "Accès refusé."
    end

    def artist_name_sql
      "COALESCE(NULLIF(TRIM(videos.artist), ''), 'Artiste inconnu')"
    end

    def artist_rows_for(window)
      Swipe.joins(video: :playlist)
           .where(created_at: window)
           .group(Arel.sql(artist_name_sql))
           .select(
             "#{artist_name_sql} AS artist_name",
             "COUNT(swipes.id) AS total_listens",
             "SUM(CASE WHEN swipes.action = 'like' THEN 1 ELSE 0 END) AS likes_count",
             "COUNT(DISTINCT swipes.user_id) AS discovered_fans_count",
             "COUNT(DISTINCT swipes.game_id) AS playlist_plays_count",
             "COUNT(DISTINCT playlists.id) AS playlists_count"
           )
           .order(Arel.sql("likes_count DESC, total_listens DESC"))
    end

    def rank_by_artist_for(window)
      rows = Swipe.joins(:video)
                  .where(created_at: window)
                  .group(Arel.sql(artist_name_sql))
                  .pluck(
                    Arel.sql(artist_name_sql),
                    Arel.sql("SUM(CASE WHEN swipes.action = 'like' THEN 1 ELSE 0 END) AS likes_count"),
                    Arel.sql("COUNT(swipes.id) AS total_listens")
                  )

      rows.sort_by { |(_, likes_count, total_listens)| [-likes_count.to_i, -total_listens.to_i] }
          .each_with_index
          .to_h { |((artist_name, _likes_count, _total_listens), index)| [artist_name, index + 1] }
    end

    def top_playlist_by_artist_for(window)
      rows = Swipe.joins(video: :playlist)
                  .where(created_at: window)
                  .group(Arel.sql(artist_name_sql), "playlists.title")
                  .pluck(
                    Arel.sql(artist_name_sql),
                    Arel.sql("playlists.title"),
                    Arel.sql("COUNT(swipes.id)")
                  )

      rows.each_with_object({}) do |(artist_name, playlist_title, listens_count), acc|
        previous = acc[artist_name]
        if previous.nil? || listens_count.to_i > previous[:listens_count]
          acc[artist_name] = { title: playlist_title, listens_count: listens_count.to_i }
        end
      end
    end
  end
end
