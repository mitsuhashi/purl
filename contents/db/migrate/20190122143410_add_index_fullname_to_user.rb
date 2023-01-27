class AddIndexFullnameToUser < ActiveRecord::Migration[5.2]
  def up
    add_index :users, :fullname
  end
  
  def down
    remove_index :users, :fullname
  end
end
