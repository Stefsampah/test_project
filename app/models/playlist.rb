class Playlist < ApplicationRecord
  has_many :videos, dependent: :destroy
  has_many :scores
  has_many :users, through: :scores
  has_many :user_playlist_unlocks
  has_many :unlocking_users, through: :user_playlist_unlocks, source: :user

  validates :title, presence: true
  validates :description, presence: true
  
  # Points requis pour débloquer si la playlist est premium
  def points_required
    premium? ? 500 : 0
  end
end
