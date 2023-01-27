class CreatePurlHistoryInfos < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
       create table purl_history_infos as select purl_infos.*, purl_maintainers_one_infos.maintainer_names, redirect_types.symbol, redirect_types.rd_type, purl_clone_infos.path clone_path, purl_clone_infos.id clone_path_id from purl_infos left join purl_maintainers_one_infos on purl_infos.id = purl_maintainers_one_infos.purl_info_id left join redirect_types on purl_infos.redirect_type_id = redirect_types.id left join clone_infos on purl_infos.id = clone_infos.purl_info_id left join purl_infos purl_clone_infos  on clone_infos.purl_info_ori_id = purl_clone_infos.id  where 1 = 2;
    SQL

    add_column :purl_history_infos, :purl_hs_id, :integer, null: false
    add_index :purl_history_infos, :purl_hs_id

    remove_column :purl_history_infos, :id

    execute <<-SQL
      alter table purl_history_infos add id serial
    SQL
  end

  def down
    execute <<-SQL
      drop table purl_history_infos
    SQL
  end
end
