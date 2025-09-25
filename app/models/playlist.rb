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
  
  # Méthode pour obtenir le thumbnail de la première vidéo de la playlist (stable)
  def first_thumbnail
    videos.first&.youtube_id
  end
  
  # Méthode pour obtenir le thumbnail de la première vidéo de la playlist (stable)
  def random_thumbnail
    first_thumbnail
  end
  
  # Méthode pour obtenir l'URL du thumbnail YouTube
  def thumbnail_url
    thumbnail_id = first_thumbnail
    if thumbnail_id
      "https://img.youtube.com/vi/#{thumbnail_id}/maxresdefault.jpg"
    else
      "https://img.youtube.com/vi/default/maxresdefault.jpg"
    end
  end
  
  # Méthode pour obtenir un thumbnail cohérent (même ID pour toute la session)
  def consistent_thumbnail
    @consistent_thumbnail ||= first_thumbnail
  end
  
  # Méthode pour obtenir l'URL du thumbnail cohérent
  def consistent_thumbnail_url
    thumbnail_id = consistent_thumbnail
    if thumbnail_id
      "https://img.youtube.com/vi/#{thumbnail_id}/maxresdefault.jpg"
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
