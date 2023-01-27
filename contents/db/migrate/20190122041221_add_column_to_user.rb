class AddColumnToUser < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :allowed_to_log_in, :boolean, default: true, null: false
  end

  def down
    remove_column :users, :allowed_to_log_in, :boolean
  end
end
