class CreatePurlMaintainerInfos < ActiveRecord::Migration[5.2]
  def up
    create_table :purl_maintainer_infos do |t|
      t.references :user, foreign_key: true, null: false
      t.references :purl_info, foreign_key: true, null: false

      t.timestamps
    end
  end

  def down
  end
end
