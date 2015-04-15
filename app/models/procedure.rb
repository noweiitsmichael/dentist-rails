class Procedure < ActiveRecord::Base
  belongs_to :practice
  belongs_to :procedure_type
  belongs_to :dentist
  belongs_to :patient
  belongs_to :claim
end
