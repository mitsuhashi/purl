class CreateDomainWritersOneInfos < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      create view domain_writers_one_infos as select domain_info_id, array_to_string(array_agg(B.username), ',') as writer_names from domain_writer_infos A left join users B on A.user_id = B.id group by domain_info_id;
    SQL
  end
  
  def down
    execute <<-SQL
      drop view domain_writers_one_infos;
    SQL
  end
end
