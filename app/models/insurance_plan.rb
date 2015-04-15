class InsurancePlan < ActiveRecord::Base
  belongs_to :practice
  has_many :claims

  validates_uniqueness_of :od_uid, :scope => :practice_id
end
