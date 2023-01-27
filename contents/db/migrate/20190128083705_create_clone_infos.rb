class CreateCloneInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :clone_infos do |t|
      t.references :purl_info, foreign_key: { to_table: :purl_infos }
      t.references :purl_info_ori, foreign_key: { to_table: :purl_infos }

      t.timestamps
    end
  end
end
