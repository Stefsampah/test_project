class CreateSeasonsAndAddSeasonFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :seasons do |t|
      t.string :name, null: false
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.boolean :active, null: false, default: false

      t.timestamps
    end

    add_index :seasons, :active
    add_index :seasons, [:starts_at, :ends_at]

    change_table :users, bulk: true do |t|
      # Points parcours comptés pour la saison en cours
      t.integer :season_journey_points, null: false, default: 0

      # Flags d'éligibilité pour la saison en cours (3 000 / 6 000 points)
      t.boolean :season_concert_link_eligible, null: false, default: false
      t.boolean :season_concert_ticket_eligible, null: false, default: false
    end
  end
end

