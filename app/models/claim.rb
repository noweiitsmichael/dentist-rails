class Claim < ActiveRecord::Base
  belongs_to :practice
  belongs_to :patient
  has_many :procedures
  belongs_to :insurance_plan

  validates_uniqueness_of :od_uid, :scope => :practice_id

  scope :sent_between, lambda { |start_date, end_date|
    where(:sent_date => start_date..end_date) 
  }

  scope :received_between, lambda { |start_date, end_date|
    where(:received_date => start_date..end_date) 
  } 
end
