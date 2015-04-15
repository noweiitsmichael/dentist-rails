class AddOduidIndexesForEverything < ActiveRecord::Migration
  def change
    add_index :claims, [:practice_id, :od_uid]
    add_index :dentists, [:practice_id, :od_uid]
    add_index :insurance_plans, [:practice_id, :od_uid]
    add_index :patients, [:practice_id, :od_uid]
    add_index :procedure_types, [:practice_id, :od_uid]
    add_index :procedures, [:practice_id, :od_uid]
  end
end
