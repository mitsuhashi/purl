class CreateGroupMaintainerInfos < ActiveRecord::Migration[5.2]
  def up
    create_table :group_maintainer_infos do |t|
      t.references :group, null: false, foreign_key: { to_table: :users }
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
