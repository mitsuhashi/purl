class AddColumnNameToDomainInfo < ActiveRecord::Migration[5.2]
  def up
    add_column :domain_infos, :name, :text, null: false
    add_index :domain_infos, :name, unique: true
  end

  def down
    remove_index :domain_infos, :name
    remove_column :domain_infos, :name, :text
  end
end
