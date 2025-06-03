class CreateRewards < ActiveRecord::Migration[7.1]
  def change
    create_table :rewards do |t|
      t.string :name
      t.text :description
      t.integer :value
      t.string :image

      t.timestamps
    end
  end
end
