class AddColumnGroupToUser < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :group_flag, :boolean, null: false, default: false
  end
  
 def down
    remove_column :users, :group_flag, :boolean
  end
end
