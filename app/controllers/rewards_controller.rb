class RewardsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Cette action est désormais dédiée uniquement aux récompenses, les badges sont gérés séparément
    @rewards = Reward.all.order(value: :desc)
  end

  def claim
    user_badge = current_user.user_badges.find(params[:id])
    
    if user_badge && user_badge.earned_at && !user_badge.claimed_at
      user_badge.update(claimed_at: Time.current)
      redirect_to rewards_path, notice: "Récompense réclamée avec succès!"
    else
      redirect_to rewards_path, alert: "Impossible de réclamer cette récompense."
    end
  end
end 