class RemoveClaimedAtFromUserBadges < ActiveRecord::Migration[7.1]
  def change
    remove_column :user_badges, :claimed_at, :datetime
  end
end
