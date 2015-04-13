class CreateInsurancePlans < ActiveRecord::Migration
  def change
    create_table :insurance_plans do |t|
      t.string  :od_uid
      t.string  :group_name
      t.integer :group_id
      t.string  :description
      t.integer :carrier_id

      t.text :open_dental_raw
      t.integer  :practice_id
      
      t.timestamps null: false
    end
  end
end
