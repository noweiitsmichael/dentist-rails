class Claim < ActiveRecord::Base
  belongs_to :practice
  belongs_to :patient
  has_many :procedures
  belongs_to :insurance_plan
end
