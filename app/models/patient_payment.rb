class PatientPayment < ActiveRecord::Base
  belongs_to :practice
  belongs_to :patient

  validates_uniqueness_of :od_uid, :scope => :practice_id

  scope :between, lambda { |start_date, end_date|
    where(:date => start_date..end_date) 
  }
end
