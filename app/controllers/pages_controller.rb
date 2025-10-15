class PagesController < ApplicationController
  def home
    # Landing page - pas besoin d'authentification
  end

  def reward_animations_demo
    # Page de démonstration des animations de récompenses
    # Accessible à tous pour les tests
  end

  def test_fullscreen
    # Page de test pour le plein écran
    # Accessible à tous pour les tests
    render layout: 'shorts'
  end
end
