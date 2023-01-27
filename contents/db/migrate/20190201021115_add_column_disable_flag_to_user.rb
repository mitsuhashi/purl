class AddColumnDisableFlagToUser < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :disable_flag, :boolean
    execute <<-SQL
      update users set disable_flag = false;
    SQL
    change_column :users, :disable_flag, :boolean, null: false
  end

  def down
    remove_column :users, :disable_flag, :boolean
  end
end
