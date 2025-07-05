class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :games
  has_many :swipes
  has_many :scores
  has_many :videos, through: :swipes
  has_many :playlists, through: :swipes
  has_one_attached :avatar

  has_many :user_badges
  has_many :badges, through: :user_badges

  has_many :user_playlist_unlocks
  has_many :unlocked_playlists, through: :user_playlist_unlocks, source: :playlist

  after_save :assign_badges
  after_create :assign_badges
  
  # Callbacks pour attribuer les badges après modification des scores
  after_save :assign_badges_after_score_change, if: :saved_change_to_swipes_count?
  after_save :assign_badges_after_score_change, if: :saved_change_to_scores_count?

  def competitor_score
    scores.sum(:points) || 0
  end

  def engager_score
    swipes.count * 10 || 0
  end

  def critic_score
    swipes.where(action: 'dislike').count * 5 || 0
  end

  def challenger_score
    (competitor_score + engager_score + critic_score) / 3 || 0
  end

  def total_points
    competitor_score + engager_score + critic_score + challenger_score
  end

  def earned_badges
    user_badges.includes(:badge).where.not(earned_at: nil)
  end

  def available_rewards
    user_badges.includes(:badge).where(claimed_at: nil).where.not(earned_at: nil)
  end

  def claim_reward!(user_badge_id)
    user_badge = user_badges.find(user_badge_id)
    user_badge.claim_reward! if user_badge.reward_available?
  end

  # Méthode de classe pour vérifier et corriger les badges de tous les utilisateurs
  def self.check_and_fix_all_badges
    User.all.each do |user|
      BadgeService.assign_badges(user)
    end
  end

  # Vérifier si l'utilisateur peut obtenir un badge spécifique
  def can_earn_badge?(badge)
    current_score = case badge.badge_type
                   when 'competitor' then competitor_score
                   when 'engager' then engager_score
                   when 'critic' then critic_score
                   when 'challenger' then challenger_score
                   end
    
    current_score >= badge.points_required && !badges.include?(badge)
  end

  # Obtenir tous les badges que l'utilisateur peut obtenir
  def obtainable_badges
    Badge.all.select { |badge| can_earn_badge?(badge) }
  end

  # Obtenir le prochain badge à obtenir pour chaque type
  def next_badges
    next_badges = {}
    
    Badge::BADGE_TYPES.each do |badge_type|
      current_score = case badge_type
                     when 'competitor' then competitor_score
                     when 'engager' then engager_score
                     when 'critic' then critic_score
                     when 'challenger' then challenger_score
                     end
      
      next_badge = Badge.where(badge_type: badge_type)
                       .where('points_required > ?', current_score)
                       .order(:points_required)
                       .first
      
      next_badges[badge_type] = {
        badge: next_badge,
        current_score: current_score,
        points_needed: next_badge ? next_badge.points_required - current_score : 0
      }
    end
    
    next_badges
  end

  private

  def assign_badges
    BadgeService.assign_badges(self)
  end
  
  def assign_badges_after_score_change
    # Attendre un peu pour s'assurer que les scores sont mis à jour
    BadgeService.assign_badges(self)
  end
end
