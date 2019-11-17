class RmColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :groups,:comment
  end
end
