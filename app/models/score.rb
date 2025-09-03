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
    top_engager = calculate_top_engager_scores
    best_ratio = calculate_best_ratio_scores
    wise_critic = calculate_wise_critic_scores

    # Combiner tous les scores avec le nouveau système
    combined_scores = {}
    
    [top_engager, best_ratio, wise_critic].each do |scores|
      scores.each do |score|
        user_id = score[:user_id]
        combined_scores[user_id] ||= { points: 0, badges: [] }
        combined_scores[user_id][:points] += score[:points]
        combined_scores[user_id][:badges].concat(score[:badges])
      end
    end

    # Attribuer les badges temporaires aux meilleurs de chaque catégorie
    if top_engager.any?
      top_engager_user_id = top_engager.first[:user_id]
      combined_scores[top_engager_user_id] ||= { points: 0, badges: [] }
      combined_scores[top_engager_user_id][:badges] << "Top Engager du jour"
    end

    if best_ratio.any?
      best_ratio_user_id = best_ratio.first[:user_id]
      combined_scores[best_ratio_user_id] ||= { points: 0, badges: [] }
      combined_scores[best_ratio_user_id][:badges] << "Top Régularité du jour"
    end

    if wise_critic.any?
      top_critic_user_id = wise_critic.first[:user_id]
      combined_scores[top_critic_user_id] ||= { points: 0, badges: [] }
      combined_scores[top_critic_user_id][:badges] << "Top Critic du jour"
    end

    # Convertir en tableau pour la vue
    combined_scores.map do |user_id, data|
      {
        user_id: user_id,
        points: data[:points],
        badges: data[:badges]
      }
    end
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
