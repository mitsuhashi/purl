class AddColumnCommentToUser < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :comment, :text
  end

  def down
    remove_column :users, :comment, :text
  end
end
