class Patient < ActiveRecord::Base
  belongs_to :practice
  has_many :procedures
  has_many :claims
end
