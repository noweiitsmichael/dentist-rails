class Procedure < ActiveRecord::Base
  belongs_to :practice
  belongs_to :procedure_type
  belongs_to :dentist
  belongs_to :patient
  belongs_to :claim

  validates_uniqueness_of :od_uid, :scope => :practice_id

  scope :between, lambda { |start_date, end_date|
    where(:date => start_date..end_date) 
  }
end
