class AddWinToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users,:win,:string
  end
end
