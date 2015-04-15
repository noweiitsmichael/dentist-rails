class Practice < ActiveRecord::Base
  belongs_to :user
  has_many :dentists
  has_many :patients
  has_many :procedures
  has_many :procedure_types
  has_many :claims
  has_many :insurance_plans

  validates_uniqueness_of :od_uid, :scope => :practice_id
end
