class AddExclusiveToPlaylists < ActiveRecord::Migration[7.1]
  def change
    add_column :playlists, :exclusive, :boolean
  end
end
