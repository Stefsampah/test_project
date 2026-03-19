class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @scores = current_user.scores.includes(:playlist)
    @recent_games = current_user.games.includes(:playlist).order(created_at: :desc).limit(6)
  end

  # Page test "Mon parcours / Concert"
  def journey
    @user = current_user
    @season = Season.current

    @season_points = @user.season_journey_points.to_i
    @link_eligible = @user.season_concert_link_eligible
    @ticket_eligible = @user.season_concert_ticket_eligible

    # Limiter la progression à 6000 pour l'affichage (100%)
    @progress_percent = [[(@season_points.to_f / 6000.0) * 100.0, 100].min, 0].max.round

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