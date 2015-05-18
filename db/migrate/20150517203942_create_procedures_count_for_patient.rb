class CreateProceduresCountForPatient < ActiveRecord::Migration
  def change
    add_column :patients, :procedures_count, :integer
  end
end
