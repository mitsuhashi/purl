class AddColumnFullnameToUser < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :fullname, :text
    execute <<-SQL
      update users set fullname = '' where fullname is null;
    SQL
    change_column :users, :fullname, :text, null: false
  end 
  
  def down
    remove_column :users, :fullname, :text
  end 
end
