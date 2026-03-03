# Phase 2 gameplay refonte : badges retirés de l'UX, redirection vers le profil
class BadgesController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to profile_path
  end

  def my_badges
    redirect_to profile_path
  end

  def all_badges
    redirect_to profile_path
  end

  def show
    redirect_to profile_path
  end
end 