class RewardsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Cette action est simplifiée car le système de badges est géré côté client
    # Néanmoins, nous pourrions ajouter certaines données ici si besoin
    
    # Quand le backend sera fonctionnel, nous pourrons faire quelque chose comme:
    # @user_badges = current_user&.user_badges&.includes(:badge) || []
    # @available_badges = Badge.all
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