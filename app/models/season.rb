class Season < ApplicationRecord
  validates :name, :starts_at, :ends_at, presence: true

  scope :active, -> { where(active: true) }

  def self.current
    active.first || where("starts_at <= ? AND ends_at >= ?", Time.current, Time.current).first
  end
end

