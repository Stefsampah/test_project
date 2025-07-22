class BadgeService
  def self.assign_badges(user)
    assign_competitor_badge(user)
    assign_engager_badge(user)
    assign_critic_badge(user)
    assign_challenger_badge(user)
  end

  private

  def self.assign_competitor_badge(user)
    score = user.total_points
    assign_badge_by_conditions(user, 'competitor', score)
  end

  def self.assign_engager_badge(user)
    score = user.total_points
    assign_badge_by_conditions(user, 'engager', score)
  end

  def self.assign_critic_badge(user)
    score = user.total_points
    assign_badge_by_conditions(user, 'critic', score)
  end

  def self.assign_challenger_badge(user)
    score = user.total_points
    assign_badge_by_conditions(user, 'challenger', score)
  end

  def self.assign_badge_by_conditions(user, badge_type, score)
    badges = Badge.where(badge_type: badge_type).order(points_required: :asc)
    
    badges.each do |badge|
      # Vérifier les conditions multiples
      next unless badge.conditions_met?(user)
      
      # Vérifier le score minimum (fallback)
      next if score < badge.points_required
      next if user.badges.include?(badge)
      
      UserBadge.create!(
        user: user,
        badge: badge,
        earned_at: Time.current,
        points_at_earned: score
      )
    end
  end

  # Méthode legacy pour compatibilité
  def self.assign_badge_by_score(user, badge_type, score)
    assign_badge_by_conditions(user, badge_type, score)
  end
end 