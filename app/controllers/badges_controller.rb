class BadgesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :all_badges]

  def index
    redirect_to my_badges_path
  end

  def my_badges
    @user_badges = current_user.user_badges.includes(:badge)
    
    # Statistiques des badges
    @bronze_count = current_user.user_badges.joins(:badge).where(badges: { level: 'bronze' }).count
    @silver_count = current_user.user_badges.joins(:badge).where(badges: { level: 'silver' }).count
    @gold_count = current_user.user_badges.joins(:badge).where(badges: { level: 'gold' }).count
    @total_badges = current_user.user_badges.count
  end

  def all_badges
    @badges = Badge.all.order(badge_type: :asc, level: :asc)
  end

  def show
    @badge = Badge.find(params[:id])
    @user_badge = current_user.user_badges.find_by(badge_id: @badge.id) if user_signed_in?
  rescue ActiveRecord::RecordNotFound
    # Rediriger vers la page des badges si le badge n'existe plus
    redirect_to all_badges_path, alert: "Ce badge n'existe plus. Voici tous les badges disponibles."
  end
end 