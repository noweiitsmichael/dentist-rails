module Hyda
  class Revenue
    def initialize(practice)
      @practice = practice.instance_of?(Practice) ? practice : Practice.find(practice)
    end

    # todo: add payments
    def avg_daily_production(start_datetime, end_datetime)
      num_days     = (end_datetime.to_date - start_datetime.to_date).to_i
      total_earned = @practice.claims.received_between(
                       start_datetime, end_datetime
                     ).sum(:payment_price)
      return (total_earned / num_days).round(2)
    end

    def insurance_collection_ratio(start_datetime, end_datetime)
      claims = @practice.claims.sent_between(start_datetime, end_datetime)
      expected_payment = claims.sum(:requested_price)
      received_payment = claims.sum(:payment_price)
      return (received_payment / expected_payment).round(2)
    end
  end
end