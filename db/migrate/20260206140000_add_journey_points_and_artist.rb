# Phase 1 refonte gameplay : parcours 5 niveaux (concert)
# - journey_points : total des points pour le parcours (like +5, dislike +1, watch +2, new_artist +10, daily_bonus +20)
# - artist sur video : pour bonus "nouvel artiste découvert" (+10)
class AddJourneyPointsAndArtist < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :journey_points, :integer, default: 0, null: false
    add_column :videos, :artist, :string
  end
end
