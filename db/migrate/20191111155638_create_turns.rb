class CreateTurns < ActiveRecord::Migration[5.2]
  def change
    create_table :turns do |t|
      t.integer :turn_num
      t.integer :group_id
      t.integer :attack_id
      t.integer :defence_id
      t.timestamps
    end
  end
end
