class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :slug
      t.string :excerpt, null: false
      t.text :content, null: false
      t.string :category
      t.string :locale, null: false, default: "fr"
      t.boolean :published, null: false, default: false
      t.datetime :published_at
      t.string :thumbnail_url
      t.string :meta_title
      t.string :meta_description

      t.timestamps
    end

    add_index :posts, :slug, unique: true
    add_index :posts, :locale
    add_index :posts, :published
    add_index :posts, :published_at
  end
end
