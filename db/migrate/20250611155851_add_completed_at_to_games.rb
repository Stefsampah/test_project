class AddCompletedAtToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :completed_at, :datetime
  end
end
