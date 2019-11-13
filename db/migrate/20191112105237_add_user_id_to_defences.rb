class AddUserIdToDefences < ActiveRecord::Migration[5.2]
  def change
    add_column :defences, :user_id, :string
  end
end
