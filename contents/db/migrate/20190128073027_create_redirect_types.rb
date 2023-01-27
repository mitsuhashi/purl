class CreateRedirectTypes < ActiveRecord::Migration[5.2]
  def up
    create_table :redirect_types do |t|
      t.string "symbol", limit: 10, null: false
      t.text  "type"

      t.timestamps
    end

    add_index :redirect_types, :symbol, unique: true, name: "rt_symbol_idx1"
  end

  def down
    remove_index "rt_symbol_idx1"
    drop_table :redirect_types
  end
end
