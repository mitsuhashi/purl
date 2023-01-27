class AddColumnNewFlagToDomainInfo < ActiveRecord::Migration[5.2]
  def up
    add_column :domain_infos, :new_flag, :boolean, null: false, default: true
  end

  def down
    remove_column :domain_infos, :new_flag, :boolean
  end
end
