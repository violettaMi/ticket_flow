class CreateExcavators < ActiveRecord::Migration[7.2]
  def change
    create_table :excavators do |t|
      t.string :company_name
      t.string :address
      t.boolean :crew_on_site, default: false
      t.references :ticket, null: false, foreign_key: true

      t.timestamps
    end
  end
end
