class AddFirstVisitDateToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :first_visit_date, :datetime
  end
end
