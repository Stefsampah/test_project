class PlaylistsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :test_layout, :test_category]

  def index
    # Scope unique: toutes les playlists jouables (plus de distinction premium/exclusive côté gameplay)
    playable_scope = Playlist.where(hidden: [false, nil]).order(:category, :subcategory, :id)

    if user_signed_in?
      played_playlist_ids = current_user.scores.pluck(:playlist_id)
      unplayed = playable_scope.where.not(id: played_playlist_ids).to_a
      played = playable_scope.where(id: played_playlist_ids).to_a
      ordered = unplayed + played
      @standard_playlists = FeedPlaylistsService.feed_60_40(current_user, ordered)
    else
      @standard_playlists = playable_scope.to_a
    end

    # Variables conservées pour compat de la vue (désormais vides)
    @premium_playlists = []
    @exclusive_playlists = []
    @unlocked_playlists = []
    @unlocked_exclusive_playlists = []
    @premium_by_category = {}
    @unlocked_by_category = {}
    @exclusive_by_category = {}

    @standard_by_category = @standard_playlists.group_by(&:category)
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
    render layout: 'shorts'
  end

  def test_layout
    base_scope = Playlist.where(hidden: [false, nil]).includes(:videos).order(:id)
    @playlists_test = base_scope.to_a

    @featured_playlist = @playlists_test.find { |p| p.category.to_s.downcase.include?("decouvrir") } || @playlists_test.first
    trending_pool = @playlists_test.reject { |p| @featured_playlist && p.id == @featured_playlist.id }
    @trending_playlists = trending_pool.shuffle.first(6)

    categories = @playlists_test.map { |p| p.category.to_s.strip }.reject(&:blank?).uniq
    @categories = categories
  end

  def test_category
    @category_name = params[:category].to_s
    base_scope = Playlist.where(hidden: [false, nil]).includes(:videos).order(:id)
    @category_playlists =
      if @category_name.casecmp("Toutes").zero?
        base_scope.to_a
      else
        base_scope.where(category: @category_name).to_a
      end
  end
end
