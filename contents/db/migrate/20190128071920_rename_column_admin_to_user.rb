class RenameColumnAdminToUser < ActiveRecord::Migration[5.2]
  def up
    rename_column :users, :admin, :admin_flag
  end
  
  def down
    rename_column :users, :admin_flag, :admin
  end
end
