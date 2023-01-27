class CreatePurlMaintainersOneInfos < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      create view purl_maintainers_one_infos as select H.purl_info_id, array_to_string(array_agg(H.username), ',') as maintainer_names from ( select A.id purl_info_id, case when A.clone_flag = true then G.username else C.username end username from purl_infos A left join purl_maintainer_infos B on A.id = B.purl_info_id left join users C on B.user_id = C.id left join clone_infos D on A.id = D.purl_info_id left join purl_infos E on D.purl_info_ori_id = E.id left join purl_maintainer_infos F on E.id = F.purl_info_id left join users G on F.user_id = G.id) H group by H.purl_info_id
    SQL
  end

  def down
    execute <<-SQL
      drop view purl_maintainers_one_infos;
    SQL
  end
end
