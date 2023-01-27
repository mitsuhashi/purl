class CreateGroupInfos < ActiveRecord::Migration[5.2]
  def up
    create_table :group_infos do |t|

      t.references :group, foreign_key: { to_table: :users }
      t.references :user, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
