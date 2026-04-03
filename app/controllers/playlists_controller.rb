require "set"

class PlaylistsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :test_categories_all, :test_trending_all, :test_category]
  before_action :set_played_playlist_ids, only: [:test_trending_all, :test_category]

  def index
    load_discover_data
  end

  def show
    @playlist = Playlist.find(params[:id])

    # Empêcher l'accès aux playlists cachées uniquement
    if @playlist.hidden?
      redirect_to playlists_path, alert: "Cette playlist n'est pas accessible."
      return
    end

    # Récupérer les vidéos non encore swipées par l'utilisateur s'il est connecté
    if user_signed_in?
      swiped_video_ids = current_user.swipes.where(playlist: @playlist).pluck(:video_id)
      @current_video = @playlist.videos.where.not(id: swiped_video_ids).first
    else
      @current_video = @playlist.videos.first
    end

    # Utiliser le layout spécial pour les shorts
    render layout: "shorts"
  end

  def redirect_legacy_playlists_test
    redirect_to playlists_path, status: :moved_permanently
  end

  def redirect_legacy_playlists_test_categories
    redirect_to playlists_categories_path, status: :moved_permanently
  end

  def redirect_legacy_playlists_test_trending
    redirect_to playlists_trending_path, status: :moved_permanently
  end

  def redirect_legacy_playlists_test_category
    redirect_to playlists_category_path(category: params[:category]), status: :moved_permanently
  end

  def test_categories_all
    base = Playlist.where(hidden: [false, nil]).includes(:videos)
    category_names = base.pluck(:category).map { |c| c.to_s.strip }.reject(&:blank?).uniq.sort
    @category_rows = category_names.filter_map do |cat|
      sample = base.where(category: cat).order(created_at: :desc).first
      next unless sample

      { category: cat, playlist: sample }
    end
  end

  def test_trending_all
    @trending_playlists = Playlist.where(hidden: [false, nil]).includes(:videos).order(created_at: :desc).to_a
  end

  def test_category
    @category_name = params[:category].to_s.strip
    base_scope = Playlist.where(hidden: [false, nil]).includes(:videos).order(created_at: :desc)
    @category_playlists =
      if @category_name.casecmp("Toutes").zero?
        base_scope.to_a
      else
        base_scope.where(category: @category_name).to_a
      end
  end

  private

  def load_discover_data
    base_scope = Playlist.where(hidden: [false, nil]).includes(:videos)
    @playlists_test = base_scope.order(:id).to_a

    @featured_playlist = @playlists_test.find { |p| p.category.to_s.downcase.include?("decouvrir") } || @playlists_test.first
    trending_scope = base_scope.order(created_at: :desc)
    exclude_id = @featured_playlist&.id
    @trending_playlists =
      if exclude_id.present?
        trending_scope.where.not(id: exclude_id).limit(8).to_a
      else
        trending_scope.limit(8).to_a
      end

    categories = @playlists_test.map { |p| p.category.to_s.strip }.reject(&:blank?).uniq
    @categories = categories.sort
  end

  def set_played_playlist_ids
    @played_playlist_ids =
      if user_signed_in?
        current_user.scores.distinct.pluck(:playlist_id).to_set
      else
        Set.new
      end
  end
end
