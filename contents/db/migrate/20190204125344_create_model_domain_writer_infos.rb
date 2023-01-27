class CreateModelDomainWriterInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :domain_writer_infos do |t|
      t.references :user, foreign_key: true, null: false
      t.references :domain_info, foreign_key: true, null: false

      t.timestamps
    end
  end
end
