class ChangeColumnTypeToRedirectType < ActiveRecord::Migration[5.2]
  def up
    change_column :redirect_types, :symbol, :text
  end
end
