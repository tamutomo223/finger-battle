class CreateTurnUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :turn_users do |t|
      t.references :turn, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
