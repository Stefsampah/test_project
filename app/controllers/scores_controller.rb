class ScoresController < ApplicationController
  before_action :authenticate_user!

  def index
    # Récupérer seulement les utilisateurs avec des scores (pas tous les utilisateurs)
    @users = User.includes(:avatar_attachment, :scores).where.not(scores: { id: nil }).distinct
    
    # Calculer les différents types de scores - LIMITÉS aux top 10
    @top_engager_scores = Score.calculate_top_engager_scores.first(10)
    @best_ratio_scores = Score.calculate_best_ratio_scores.first(10)
    @wise_critic_scores = Score.calculate_wise_critic_scores.first(10)
    @total_scores = Score.calculate_total_scores.first(10)
    
    # Précharger tous les utilisateurs avec leurs avatars pour éviter les requêtes N+1
    user_ids = (@top_engager_scores.map { |s| s[:user_id] } + 
                @best_ratio_scores.map { |s| s[:user_id] } + 
                @wise_critic_scores.map { |s| s[:user_id] } + 
                @total_scores.map { |s| s[:user_id] }).uniq
    @users_by_id = User.includes(avatar_attachment: :blob).where(id: user_ids).index_by(&:id)

    # Récupérer seulement les playlists avec des scores - LIMITÉES aux 5 plus populaires
    @scores_by_playlist = Playlist.includes(scores: :user)
                                 .joins(:scores)
                                 .group('playlists.id')
                                 .order('COUNT(scores.id) DESC')
                                 .limit(5)
                                 .map do |playlist|
      [playlist, playlist.scores.order(points: :desc).limit(10)]
    end
    
    # Récupérer les scores de l'utilisateur connecté
    @my_scores = current_user.scores.includes(:playlist).order(points: :desc)
    @my_scores_by_playlist = @my_scores.group_by(&:playlist)
  end

  def show
    @playlist = Playlist.find(params[:id])
    @scores = Score.includes(:user)
                  .where(playlist: @playlist)
                  .order(points: :desc)
  end
end
