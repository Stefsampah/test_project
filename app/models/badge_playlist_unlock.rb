class BadgePlaylistUnlock < ApplicationRecord
  belongs_to :badge
  belongs_to :playlist

  validates :badge_id, presence: true
  validates :playlist_id, presence: true
  validates :badge_id, uniqueness: { scope: :playlist_id }
end 