class UpdateBadges < ActiveRecord::Migration[6.1]
  def change
    # La table badges existe déjà, on va juste ajouter la colonne icon_url si elle n'existe pas
    unless column_exists?(:badges, :icon_url)
      add_column :badges, :icon_url, :string
    end
  end
end 