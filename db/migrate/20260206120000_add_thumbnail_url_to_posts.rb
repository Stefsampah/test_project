class AddThumbnailUrlToPosts < ActiveRecord::Migration[7.1]
  def change
    return if column_exists?(:posts, :thumbnail_url)

    add_column :posts, :thumbnail_url, :string
  end
end
