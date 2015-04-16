module PracticesHelper
  def format_rev_line_chart_data(rev_hist)
    rev_hist.map do |r|
      r['period'] = r[:start_date].strftime("%Y-%m-%d")
      r['paid_claims'] = r[:paid_claims].to_i
      r['unpaid_claims'] = r[:unpaid_claims].to_i
      r['payments'] = r[:payments].to_i
      r
    end
  end

  def format_production_area_chart_data(production)
    production.map do |p|
      p['period'] = p[:start_date].strftime("%Y-%m-%d")
      p['avg_price_per_procedure'] = p[:avg_price_per_procedure].to_i
      p['total_price'] = p[:total_price].to_i
      p
    end
  end

  def float_to_percent(price)
    price_to_s = '%.1f' % price
    "#{price_to_s}%"
  end
end