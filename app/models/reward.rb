class Reward < ApplicationRecord
  validates :name, :description, :value, presence: true
  validates :value, numericality: { greater_than: 0 }
end 