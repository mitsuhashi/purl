class CreatePurlMaintainersScInfos < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      create view purl_maintainer_sc_infos as select A.id purl_info_id, case when A.clone_flag = true then G.id else C.id end user_id from purl_infos A left join purl_maintainer_infos B on A.id = B.purl_info_id left join users C on B.user_id = C.id left join clone_infos D on A.id = D.purl_info_id left join purl_infos E on D.purl_info_ori_id = E.id left join purl_maintainer_infos F on E.id = F.purl_info_id left join users G on F.user_id = G.id
    SQL
  end

  def down
    execute <<-SQL
      drop view purl_maintainer_sc_infos;
    SQL
  end
end
