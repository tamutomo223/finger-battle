class CreateAttacks < ActiveRecord::Migration[5.2]
  def change
    create_table :attacks do |t|
      t.integer :turn_id
      t.integer :right
      t.integer :left
      t.timestamps
    end
  end
end
