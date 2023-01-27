class AddIndexAffiliationToUser < ActiveRecord::Migration[5.2]
  def up
    add_index :users, :affiliation
  end

  def down
    remove_index :users, :affiliation
  end
end
