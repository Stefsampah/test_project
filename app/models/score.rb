class Score < ApplicationRecord
  belongs_to :user
  belongs_to :playlist

  validates :points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :user_id, presence: true
  validates :playlist_id, presence: true

  # Méthodes pour calculer les différents types de scores (SYSTÈME SIMPLIFIÉ)
  def self.calculate_top_engager_scores
    # Utiliser le nouveau système simplifié
    User.all.map do |user|
      {
        user_id: user.id,
        points: user.listening_points + user.critical_opinions_points,
        badges: []
      }
    end.sort_by { |score| -score[:points] }
  end

  def self.calculate_best_ratio_scores
    # Utiliser le nouveau système simplifié (régularité)
    User.all.map do |user|
      {
        user_id: user.id,
        points: user.regularity_points,
        badges: []
      }
    end.sort_by { |score| -score[:points] }
  end

  def self.calculate_wise_critic_scores
    # Utiliser le nouveau système simplifié
    User.all.map do |user|
      {
        user_id: user.id,
        points: user.critical_opinions_points,
        badges: []
      }
    end.sort_by { |score| -score[:points] }
  end

  def self.calculate_total_scores
    # Utiliser directement le score global de chaque utilisateur
    User.all.map do |user|
      {
        user_id: user.id,
        points: user.game_points,
        badges: []
      }
    end.sort_by { |score| -score[:points] }
  end

  def badges
    badges = []
  
    # Ajout du badge "Best Ratio du jour"
    interaction = Swipe.group(:user_id).select("user_id, 
      SUM(CASE WHEN action = 'like' THEN 1 ELSE 0 END) as likes, 
      SUM(CASE WHEN action = 'dislike' THEN 1 ELSE 0 END) as dislikes").find_by(user_id: user_id)
  
    if interaction.present?
      total = interaction.likes + interaction.dislikes
      if total > 0
        ratio = (interaction.likes.to_f / total) * 100
        badges << "Best Ratio du jour" if ratio.between?(40, 60)
  
        # Ajout du badge "Wise Critic du jour"
        like_proportion = (interaction.likes.to_f / total) * 100
        dislike_proportion = (interaction.dislikes.to_f / total) * 100
        gap = (like_proportion - dislike_proportion).abs
        badges << "Wise Critic du jour" if gap <= 20
      end
    end
  
    badges
  end
   
end
