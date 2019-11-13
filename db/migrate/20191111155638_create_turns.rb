class CreateTurns < ActiveRecord::Migration[5.2]
  def change
    create_table :turns do |t|
      t.string :turn_num,optional: true
      t.string :group_id,optional: true
      t.string :attack_id,optional: true
      t.string :defence_id,optional: true
      t.timestamps
    end
  end
end
