class Patient < ActiveRecord::Base
  belongs_to :practice
  has_many :procedures
  has_many :claims

  validates_uniqueness_of :od_uid, :scope => :practice_id
end
