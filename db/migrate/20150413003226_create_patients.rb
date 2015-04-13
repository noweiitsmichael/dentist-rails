class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string  :od_uid
      t.integer :zipcode
      t.integer :gender

      t.text :open_dental_raw
      t.integer  :practice_id
     
      t.timestamps null: false
    end
  end
end
