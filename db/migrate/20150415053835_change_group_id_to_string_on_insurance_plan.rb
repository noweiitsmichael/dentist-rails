class ChangeGroupIdToStringOnInsurancePlan < ActiveRecord::Migration
  def change
    remove_column :insurance_plans, :group_id
    add_column :insurance_plans, :group_id, :string
  end
end
