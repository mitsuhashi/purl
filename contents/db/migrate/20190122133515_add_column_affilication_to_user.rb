class AddColumnAffilicationToUser < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :affiliation, :text
  end
  def down
    remove_column :users, :affiliation, :text
  end
end
