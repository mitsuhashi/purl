class AddColumnJustificationToUser < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :justification, :text
  end

  def down
    remove_column :users, :justification, :text
  end
end
