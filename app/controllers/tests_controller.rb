class TestsController < ApplicationController
  def check_user
    if user_signed_in?
      render json: {
        signed_in: true,
        user_id: current_user.id,
        email: current_user.email,
        username: current_user.username,
        points: current_user.points,
        vip: current_user.vip,
        created_at: current_user.created_at,
        updated_at: current_user.updated_at
      }
    else
      render json: { signed_in: false }
    end
  end

  def debug_user
    if user_signed_in?
      @user = current_user
      @scores = current_user.scores.includes(:playlist)
      @badges = current_user.user_badges.includes(:badge)
    else
      redirect_to new_user_session_path, alert: "Vous devez être connecté pour voir cette page."
    end
  end
end
  

