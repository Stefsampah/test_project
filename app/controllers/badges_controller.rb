class BadgesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :all_badges]

  def index
    redirect_to my_badges_path
  end

  def my_badges
    @user_badges = current_user.user_badges.includes(:badge)
  end

  def all_badges
    @badges = Badge.all.order(badge_type: :asc, level: :asc)
  end

  def show
    @badge = Badge.find(params[:id])
    @user_badge = current_user.user_badges.find_by(badge_id: @badge.id) if user_signed_in?
  end

  def claim_reward
    user_badge = current_user.user_badges.find(params[:id])
    
    if user_badge && user_badge.earned_at && !user_badge.claimed_at
      user_badge.update(claimed_at: Time.current)
      redirect_to badge_path(user_badge.badge), notice: "Récompense réclamée avec succès!"
    else
      redirect_to badge_path(user_badge.badge), alert: "Impossible de réclamer cette récompense."
    end
  end
end 