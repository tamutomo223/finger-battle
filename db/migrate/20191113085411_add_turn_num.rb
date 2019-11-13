class AddTurnNum < ActiveRecord::Migration[5.2]
  def change
    add_column :attacks, :turn_num, :string
  end
end
