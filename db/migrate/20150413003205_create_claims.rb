class CreateClaims < ActiveRecord::Migration
  def change
    create_table :claims do |t|
      t.string   :od_uid
      t.integer  :patient_id
      t.datetime :service_date
      t.datetime :sent_date
      t.datetime :received_date
      t.integer  :status
      t.integer  :insurance_plan_id
      t.float    :requested_price
      t.float    :payment_price
      t.string   :claim_type

      t.text :open_dental_raw
      t.integer  :practice_id

      t.timestamps null: false
    end
  end
end
