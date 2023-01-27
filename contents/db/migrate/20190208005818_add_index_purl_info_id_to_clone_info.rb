class AddIndexPurlInfoIdToCloneInfo < ActiveRecord::Migration[5.2]
  def up
    remove_index :clone_infos, :purl_info_id
    add_index :clone_infos, :purl_info_id, :unique => true
  end

  def down
    remove_index :clone_infos, :purl_info_id
  end
end
