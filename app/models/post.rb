class Post < ApplicationRecord
  validates :title, :excerpt, :content, :locale, presence: true
  validates :slug, uniqueness: true, allow_blank: true

  scope :published, lambda {
    where(published: true)
      .where("published_at IS NULL OR published_at <= ?", Time.current)
  }
  scope :in_locale, ->(locale) { where(locale: locale.to_s) }

  before_validation :set_slug

  def to_param
    slug.presence || id.to_s
  end

  private

  def set_slug
    return unless title.present?

    self.slug = title.parameterize if slug.blank?
  end
end
