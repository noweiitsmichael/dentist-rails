class Dentist < ActiveRecord::Base
  belongs_to :practice
  has_many :procedures

  validates_uniqueness_of :od_uid, :scope => :practice_id
end
