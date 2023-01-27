class CreateUserHistoryInfos < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      create table user_history_infos as select * from users where 1 = 2;
    SQL

    add_column :user_history_infos, :user_hs_id, :integer, null: false
    add_index :user_history_infos, :user_hs_id

    remove_column :user_history_infos, :id

    execute <<-SQL
      alter table user_history_infos add id serial
    SQL
  end

  def down
    execute <<-SQL
      drop table user_history_infos
    SQL
  end
end
