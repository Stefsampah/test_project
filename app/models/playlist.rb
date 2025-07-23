class Playlist < ApplicationRecord
  has_many :scores
  has_many :games
  has_many :videos
  has_many :user_playlist_unlocks
  has_many :unlocked_users, through: :user_playlist_unlocks, source: :user
  has_many :badge_playlist_unlocks
  has_many :unlocking_badges, through: :badge_playlist_unlocks, source: :badge

  validates :title, presence: true
  validates :description, presence: true
  
  # Points requis pour débloquer si la playlist est premium
  def points_required
    premium? ? 500 : 0
  end
end
