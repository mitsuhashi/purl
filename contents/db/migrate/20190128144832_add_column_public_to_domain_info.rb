class AddColumnPublicToDomainInfo < ActiveRecord::Migration[5.2]
  def up
    add_column :domain_infos, :public_flag, :boolean, null: false, default: false
    add_index :domain_infos, :public_flag
  end

  def down
    remove_index :domain_infos, :public_flag
    remove_column :domain_infos, :public_flag, :boolean
  end
end
