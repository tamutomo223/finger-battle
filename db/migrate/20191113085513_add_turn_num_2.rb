class AddTurnNum2 < ActiveRecord::Migration[5.2]
  def change
    add_column :defences, :turn_num, :string
  end
end
