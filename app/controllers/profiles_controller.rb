class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @scores = current_user.scores.includes(:playlist)
    @badges = current_user.user_badges.includes(:badge)
    @badges = current_user.user_badges.includes(:badge)
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