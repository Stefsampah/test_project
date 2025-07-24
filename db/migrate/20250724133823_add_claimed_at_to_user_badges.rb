class AddClaimedAtToUserBadges < ActiveRecord::Migration[7.1]
  def change
    add_column :user_badges, :claimed_at, :datetime
  end
end
