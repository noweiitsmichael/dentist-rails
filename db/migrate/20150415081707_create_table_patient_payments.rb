class CreateTablePatientPayments < ActiveRecord::Migration
  def change
    create_table :patient_payments do |t|
      t.string   :od_uid
      t.datetime :date
      t.float    :amount
      t.integer  :patient_id

      t.text     :open_dental_raw
      t.integer  :practice_id

      t.timestamps null: false
    end
  end
end
