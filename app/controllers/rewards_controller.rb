class RewardsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Cette action affiche maintenant les badges gagnés et leurs récompenses
    @user_badges = current_user.user_badges.includes(:badge) if user_signed_in?
  end
end 