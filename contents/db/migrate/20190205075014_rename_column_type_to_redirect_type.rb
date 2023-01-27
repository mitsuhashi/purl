class RenameColumnTypeToRedirectType < ActiveRecord::Migration[5.2]
  def up
    rename_column :redirect_types, :type, :rd_type
  end
  
  def down
    rename_column :redirect_types, :rd_type, :type
  end
end
