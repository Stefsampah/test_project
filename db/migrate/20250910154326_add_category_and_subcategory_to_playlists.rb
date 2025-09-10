class AddCategoryAndSubcategoryToPlaylists < ActiveRecord::Migration[7.1]
  def change
    add_column :playlists, :category, :string
    add_column :playlists, :subcategory, :string
  end
end
