class InsurancePlan < ActiveRecord::Base
  belongs_to :practice
  has_many :claims
end
