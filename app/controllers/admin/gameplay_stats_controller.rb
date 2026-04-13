module Admin
  class GameplayStatsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin!

    def index
      @users_count = User.count
      @active_users_7d = User.joins(:games).where(games: { created_at: 7.days.ago..Time.current }).distinct.count
      @new_users_7d = User.where(created_at: 7.days.ago..Time.current).count

      recent_swipes = Swipe.where(created_at: 7.days.ago..Time.current)
      @swipes_7d = recent_swipes.count
      @likes_7d = recent_swipes.where(action: "like").count
      @dislikes_7d = recent_swipes.where(action: "dislike").count
      @average_watch_seconds = recent_swipes.average(:watched_seconds).to_f.round(1)

      @plays_started_7d = Game.where(created_at: 7.days.ago..Time.current).count
      @plays_completed_7d = Game.where(completed_at: 7.days.ago..Time.current).count
      @completion_rate_7d =
        if @plays_started_7d.zero?
          0.0
        else
          ((@plays_completed_7d.to_f / @plays_started_7d) * 100).round(1)
        end

      @users_3000 = User.where("journey_points >= 3000").count
      @users_6000 = User.where("journey_points >= 6000").count
      @users_near_3000 = User.where(journey_points: 2500...3000).order(journey_points: :desc).limit(10)
      @users_near_6000 = User.where(journey_points: 5500...6000).order(journey_points: :desc).limit(10)
      @top_weekly_progress = top_weekly_progress_users

      @top_spam_like_users = spam_ratio_users("like")
      @top_spam_dislike_users = spam_ratio_users("dislike")
    end

    private

    def spam_ratio_users(action)
      total_sql = "COUNT(swipes.id)"
      action_sql = "SUM(CASE WHEN swipes.action = '#{action}' THEN 1 ELSE 0 END)"
      ratio_sql = "(#{action_sql} * 1.0 / NULLIF(#{total_sql}, 0))"

      User.joins(:swipes)
          .where(swipes: { created_at: 7.days.ago..Time.current })
          .group("users.id")
          .having("COUNT(swipes.id) >= 15")
          .select("users.id, users.email, #{total_sql} AS swipes_count, #{ratio_sql} AS ratio")
          .order("ratio DESC")
          .limit(10)
    end

    def top_weekly_progress_users
      users = User.includes(:swipes).to_a
      users.map do |user|
        swipes = user.swipes.where(created_at: 7.days.ago..Time.current)
        progress = swipes.sum do |s|
          case s.action
          when "like" then 5
          when "dislike" then 1
          else 0
          end
        end
        { user: user, points: progress, swipes_count: swipes.size }
      end.select { |row| row[:points].positive? }
           .sort_by { |row| -row[:points] }
           .first(10)
    end

    def ensure_admin!
      return if current_user&.admin?

      redirect_to root_path, alert: "Accès refusé."
    end
  end
end
