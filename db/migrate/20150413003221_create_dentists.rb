class CreateDentists < ActiveRecord::Migration
  def change
    create_table :dentists do |t|
      t.string :od_uid
      t.string :first_name
      t.string :last_name
      t.string :suffix
      
      t.text :open_dental_raw
      t.integer  :practice_id
     
      t.timestamps null: false
    end
  end
end
