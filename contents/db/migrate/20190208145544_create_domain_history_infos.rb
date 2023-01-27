class CreateDomainHistoryInfos < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      create table domain_history_infos as select domain_infos.*, domain_maintainers_one_infos.maintainer_names, domain_writers_one_infos.writer_names from domain_infos join domain_maintainers_one_infos on domain_infos.id = domain_maintainers_one_infos.domain_info_id left join domain_writers_one_infos on domain_infos.id = domain_writers_one_infos.domain_info_id where 1 = 2
    SQL
    
    add_column :domain_history_infos, :domain_hs_id, :integer, null: false
    add_index :domain_history_infos, :domain_hs_id

    remove_column :domain_history_infos, :id

    execute <<-SQL
      alter table domain_history_infos add id serial
    SQL
  end

  def down
    execute <<-SQL
      drop table domain_history_infos
    SQL
  end
end
