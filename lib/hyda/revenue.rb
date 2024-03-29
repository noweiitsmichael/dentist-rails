module Hyda
  class Revenue
    def initialize(practice)
      @practice = practice.instance_of?(Practice) ? practice : Practice.find(practice)
    end

    def avg_daily_revenue(start_datetime, end_datetime)
      num_days      = (end_datetime.to_date - start_datetime.to_date).to_i
      total_earned  = @practice.claims.received_between(
                        start_datetime, end_datetime
                      ).sum(:payment_price)
      total_earned += @practice.patient_payments.between(
                        start_datetime, end_datetime
                      ).sum(:amount)
      return (total_earned / num_days).round(2)
    end

    def insurance_collection_ratio(start_datetime, end_datetime)
      claims = @practice.claims.sent_between(start_datetime, end_datetime)
      expected_payment = claims.sum(:requested_price)
      received_payment = claims.sum(:payment_price)
      return (received_payment / expected_payment).round(2)
    end

    def revenue_per(base_time_unit_interval, num_units, start_datetime)
      end_datetime  = start_datetime + (num_units * base_time_unit_interval).seconds

      payments_by_unit_index      = @practice.patient_payments.between(
                                      start_datetime, end_datetime
                                    ).group_by do |p|
                                      ((p.date - start_datetime).to_i.seconds / base_time_unit_interval).to_i
                                    end

      paid_claims_by_unit_index   = @practice.claims.paid_between(
                                      start_datetime, end_datetime
                                    ).group_by do |c|
                                      ((c.sent_date - start_datetime).to_i.seconds / base_time_unit_interval).to_i
                                    end

      unpaid_claims_by_unit_index = @practice.claims.unpaid_between(
                                      start_datetime, end_datetime
                                    ).group_by do |c|
                                      ((c.sent_date - start_datetime).to_i.seconds / base_time_unit_interval).to_i
                                    end
      
      revenue = []
      num_units.times do |i|
        payments      = payments_by_unit_index[i] || PatientPayment.none
        paid_claims   = paid_claims_by_unit_index[i] || Claim.none
        unpaid_claims = unpaid_claims_by_unit_index[i] || Claim.none

        revenue.push({
          :start_date    => start_datetime + (i * base_time_unit_interval).seconds,
          :end_date      => start_datetime + ((i + 1) * base_time_unit_interval).seconds, 
          :payments      => payments.sum(&:amount).round(2),
          :paid_claims   => paid_claims.sum(&:payment_price).round(2),
          :unpaid_claims => unpaid_claims.sum(&:requested_price).round(2)
        })
      end

      return revenue
    end

    def production_per(base_time_unit_interval, num_units, start_datetime)
      end_datetime  = start_datetime + (num_units * base_time_unit_interval).seconds

      procedures_by_unit_index = @practice.procedures.between(
                                   start_datetime, end_datetime
                                 ).group_by do |p|
                                   ((p.date - start_datetime).to_i.seconds / base_time_unit_interval).to_i
                                 end
      
      production = []
      num_units.times do |i|
        procedures = procedures_by_unit_index[i] || Procedure.none
        total_price = procedures.sum(&:price)
        
        production.push({
          :start_date    => start_datetime + (i * base_time_unit_interval).seconds,
          :end_date      => start_datetime + ((i + 1) * base_time_unit_interval).seconds,
          :total_price => total_price.round(2),
          :num_procedures => procedures.length,
          :avg_price_per_procedure => procedures.length > 0 ? (total_price / procedures.length).round(2) : 0
        })
      end

      return production
    end
  end
end