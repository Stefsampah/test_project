class PagesController < ApplicationController
  def home
    # Landing page - pas besoin d'authentification
  end

  def reward_animations_demo
    # Page de démonstration des animations de récompenses
    # Accessible à tous pour les tests
  end

  def reward_cards_proposals
    # Page de propositions de design pour les cartes de récompenses
    # Accessible à tous pour les tests
  end

  def journey_test_1
    # Proposition 1: Neon Arena
  end

  def journey_test_2
    # Proposition 2: Ticket Collector
  end

  def journey_test_2_old
    # Snapshot version from previous stopping point
  end

  def journey_test_3
    # Proposition 3: Cinematic Story
  end

  def test_fullscreen
    # Page de test pour le plein écran
    # Accessible à tous pour les tests
    render layout: 'shorts'
  end

  def about
    # Page "À propos" pour le SEO et la présentation du projet
  end

  def blog
    # Page "Blog" pour le SEO et le contenu éditorial
  end
end
