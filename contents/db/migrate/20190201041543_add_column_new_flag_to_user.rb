class AddColumnNewFlagToUser < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :new_flag, :boolean
    execute <<-SQL
      update users set new_flag = false;
    SQL
    change_column :users, :new_flag, :boolean, null: false
  end

  def down
    remove_column :users, :new_flag, :boolean
  end
end
