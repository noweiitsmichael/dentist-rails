class Patient < ActiveRecord::Base
  belongs_to :practice
  has_many :procedures
  has_many :claims
  has_many :payments

  validates_uniqueness_of :od_uid, :scope => :practice_id

  scope :new_since, lambda { |date| where("first_visit_date > ?", date) }
  scope :new_since_today, lambda {
    new_since(DateTime.now.beginning_of_day)
  }
  scope :new_since_yesterday, lambda {
    new_since((DateTime.now - 1.day).beginning_of_day)
  }
  scope :new_since_last_week, lambda {
    new_since((DateTime.now - 1.week).beginning_of_day)
  }
  scope :new_since_last_month, lambda {
    new_since((DateTime.now - 1.month).beginning_of_day)
  }
  scope :new_between, lambda { |start_date, end_date|
    where(:first_visit_date => start_date..end_date) 
  }
end
