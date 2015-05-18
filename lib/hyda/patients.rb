module Hyda
  class Patients
    def initialize(practice)
      @practice = practice.instance_of?(Practice) ? practice : Practice.find(practice)
    end

    def new_between_with_completed_procedures(start_date, end_date)
      Patient.joins(:procedures).where(
        :first_visit_date => start_date..end_date,
        :status => Patient.active_status,
        "procedures.status" => Procedure.completed_status,
        "procedures.date" => start_date..end_date
      ).where("procedures.price > ?", 0).uniq
    end
  end
end