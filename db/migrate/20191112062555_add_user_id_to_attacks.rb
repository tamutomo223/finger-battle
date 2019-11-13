class AddUserIdToAttacks < ActiveRecord::Migration[5.2]
  def change
    add_column :attacks, :user_id, :string
  end
end
