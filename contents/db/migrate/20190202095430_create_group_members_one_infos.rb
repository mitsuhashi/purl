class CreateGroupMembersOneInfos < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      create view group_members_one_infos as select group_id user_id, array_to_string(array_agg(B.username), ',') as member_names from group_infos A left join users B on A.user_id = B.id group by group_id
    SQL
  end

  def down
    execute <<-SQL
      drop view group_members_one_infos
    SQL
  end
end
