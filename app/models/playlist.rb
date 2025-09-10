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
  
  # Méthode pour obtenir le thumbnail aléatoire d'une vidéo de la playlist
  def random_thumbnail
    videos.sample&.youtube_id
  end
  
  # Méthode pour obtenir l'URL du thumbnail YouTube
  def thumbnail_url
    if random_thumbnail
      "https://img.youtube.com/vi/#{random_thumbnail}/maxresdefault.jpg"
    else
      "https://img.youtube.com/vi/default/maxresdefault.jpg"
    end
  end
  
  # Méthode pour obtenir la catégorie complète
  def full_category
    if category.present? && subcategory.present?
      "#{category} > #{subcategory}"
    elsif category.present?
      category
    else
      genre
    end
  end
end
