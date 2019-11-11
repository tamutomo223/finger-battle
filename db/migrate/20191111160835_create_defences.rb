class CreateDefences < ActiveRecord::Migration[5.2]
  def change
    create_table :defences do |t|
      t.integer :turn_id
      t.integer :right
      t.integer :left
      t.timestamps
    end
  end
end
