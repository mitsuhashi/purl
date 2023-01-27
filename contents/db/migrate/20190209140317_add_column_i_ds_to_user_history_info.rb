class AddColumnIDsToUserHistoryInfo < ActiveRecord::Migration[5.2]
  def up
    add_column :user_history_infos, :maintainer_names, :text
    add_column :user_history_infos, :member_names, :text
  end
end
