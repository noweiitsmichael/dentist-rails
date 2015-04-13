class CreateProcedures < ActiveRecord::Migration
  def change
    create_table :procedures do |t|
      t.string   :od_uid
      t.integer  :patient_id
      t.integer  :dentist_id
      t.integer  :procedure_type_id
      t.integer  :claim_id
      t.integer  :insurance_plan_id
      t.float    :price
      t.integer  :status
      t.datetime :date

      t.text :open_dental_raw
      t.integer  :practice_id

      t.timestamps null: false
    end
  end
end
