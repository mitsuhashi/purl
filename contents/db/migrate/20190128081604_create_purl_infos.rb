class CreatePurlInfos < ActiveRecord::Migration[5.2]
  def up
    create_table :purl_infos do |t|
      t.text "path", null: false
      t.text "target"
      t.text "see_also_url"
      t.boolean "clone_flag", default: false, null: false
      t.boolean "chain_flag", default: false, null: false
      t.boolean "disable_flag", default: false, null: false
      t.references :redirect_type, foreign_key: true, null: false

      t.timestamps
    end

    add_index :purl_infos, :path, unique: true, name: "purl_info_idx1"
    add_index :purl_infos, :target, name: "purl_info_idx2"
    add_index :purl_infos, :see_also_url, name: "purl_info_idx3"
    add_index :purl_infos, :clone_flag, name: "purl_info_idx4"
    add_index :purl_infos, :chain_flag, name: "purl_info_idx5"
    add_index :purl_infos, :disable_flag, name: "purl_info_idx6"
    add_index :purl_infos, :redirect_type_id, name: "purl_info_idx7"
  end

  def down
  end
end
