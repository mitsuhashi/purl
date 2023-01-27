class AddIndexGroupToUser < ActiveRecord::Migration[5.2]
  def up
    add_index :users, :group_flag
  end
  
  def down
    remove_index :users, :group_flag
  end
end
