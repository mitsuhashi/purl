class CreateDomainInfos < ActiveRecord::Migration[5.2]
  def up
    create_table :domain_infos do |t|
      t.text :domain_id, null: false
      t.boolean :disable_flag, null: false, default: false
      t.timestamps
    end

    add_index :domain_infos, :domain_id, unique: true, name: "domain_infos_idx1"
  end

  def down
  end
end
