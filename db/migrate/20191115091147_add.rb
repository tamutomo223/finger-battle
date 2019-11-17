class Add < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :comment, :text
  end
end
