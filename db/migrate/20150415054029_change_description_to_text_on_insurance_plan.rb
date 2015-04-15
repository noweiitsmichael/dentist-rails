class ChangeDescriptionToTextOnInsurancePlan < ActiveRecord::Migration
  def change
    remove_column :insurance_plans, :description
    add_column :insurance_plans, :description, :text
  end
end
