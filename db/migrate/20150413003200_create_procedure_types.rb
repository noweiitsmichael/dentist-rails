class CreateProcedureTypes < ActiveRecord::Migration
  def change
    create_table :procedure_types do |t|
      t.string :od_uid
      t.string :code
      t.text   :description

      t.text :open_dental_raw
      t.integer  :practice_id

      t.timestamps null: false
    end
  end
end
