class CreateTickets < ActiveRecord::Migration[7.2]
  def change
    create_table :tickets do |t|
      t.string :request_number
      t.integer :sequence_number
      t.string :request_type
      t.datetime :response_time
      t.string :primary_service_area_code
      t.string :additional_service_area_codes, array: true, default: []
      t.text :dig_site_info

      t.timestamps
    end
  end
end
