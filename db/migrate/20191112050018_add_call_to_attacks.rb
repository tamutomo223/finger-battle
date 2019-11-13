class AddCallToAttacks < ActiveRecord::Migration[5.2]
  def change
    add_column :attacks, :call, :string
  end
end
