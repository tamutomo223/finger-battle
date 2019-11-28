class AddLoseToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users,:lose,:string
  end
end
