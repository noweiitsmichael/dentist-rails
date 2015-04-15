class Dentist < ActiveRecord::Base
  belongs_to :practice
  has_many :procedures
end
