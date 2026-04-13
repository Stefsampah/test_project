class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @scores = current_user.scores.includes(:playlist)
    @recent_games = current_user.games.includes(:playlist).order(created_at: :desc).limit(6)

    recent_swipes = current_user.swipes.where(created_at: 30.days.ago..Time.current)
    likes_count = recent_swipes.where(action: "like").count
    dislikes_count = recent_swipes.where(action: "dislike").count
    total_actions = likes_count + dislikes_count

    @watch_avg_seconds = recent_swipes.average(:watched_seconds).to_f.round(1)
    @completion_rate =
      if current_user.games.count.zero?
        0.0
      else
        ((current_user.games.where.not(completed_at: nil).count.to_f / current_user.games.count) * 100).round(1)
      end
    @like_ratio_percent = total_actions.zero? ? 0.0 : ((likes_count.to_f / total_actions) * 100).round(1)
    @dislike_ratio_percent = total_actions.zero? ? 0.0 : ((dislikes_count.to_f / total_actions) * 100).round(1)

    last_completed_game = current_user.games.where.not(completed_at: nil).order(completed_at: :desc).first
    @anti_abuse_modifier = last_completed_game.present? ? ScoringService.anti_abuse_multiplier(last_completed_game) : 1.0
  end

  # Page test "Mon parcours / Concert"
  def journey
    @user = current_user
    @season = Season.current

    @journey_points = @user.journey_points.to_i
    @link_eligible = @user.season_concert_link_eligible
    @ticket_eligible = @user.season_concert_ticket_eligible

    # Limiter la progression à 4500 pour l'affichage (100%)
    @progress_percent = [[(@journey_points.to_f / 4500.0) * 100.0, 100].min, 0].max.round

    # Playlists restantes aujourd'hui (free vs VIP)
    if @user.vip?
      @remaining_playlists_today = :unlimited
    else
      games_today = @user.games.where(created_at: Time.current.all_day).count
      max_daily = GamesController::MAX_DAILY_GAMES_FREE
      @remaining_playlists_today = [max_daily - games_today, 0].max
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    
    # Debug: afficher les paramètres reçus
    Rails.logger.info "Params reçus: #{params.inspect}"
    
    if @user.update(user_params)
      redirect_to profile_path, notice: 'Profil mis à jour avec succès!'
    else
      Rails.logger.error "Erreurs de validation: #{@user.errors.full_messages}"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # Gérer les deux cas possibles
    if params[:user].present?
      # Cas normal avec namespace user
      params.require(:user).permit(:avatar, :username, :email)
    elsif params[:avatar].present? || params[:username].present? || params[:email].present?
      # Cas où les paramètres viennent directement
      params.permit(:avatar, :username, :email)
    else
      # Fallback - permettre tous les paramètres autorisés
      params.permit(:avatar, :username, :email)
    end
  end
end 