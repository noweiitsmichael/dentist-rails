class PracticesController < ApplicationController
  include ActionView::Helpers::NumberHelper
  include PracticesHelper

  before_filter :set_practice

  def index
    @rev = Hyda::Revenue.new(@practice)
    @appointments = []
    @dentists = []
    @production = []

    load_summary_metrics
    load_day_to_day
    load_chart_data   

    js :rev_hist => @rev_chart_data
    js :production => @prod_chart_data

  end

  private

  def set_practice
    @practice = Practice.last
  end

  def load_summary_metrics
    @est_prod_this_mo = @rev.production_per(1.month, 1, DateTime.now.beginning_of_month)[0][:total_price]
    @avg_rev_this_mo = @rev.avg_daily_revenue(DateTime.now.beginning_of_month, DateTime.now)
    @avg_ins_ratio_this_mo = @rev.insurance_collection_ratio(DateTime.now.beginning_of_month, DateTime.now)
    @new_patients_this_mo = @practice.patients.new_since(DateTime.now.beginning_of_month).count
  end

  def load_day_to_day
    ## TODO: change to 7 if we update to 7 days
    ## TODO: Start at beginning of week (Monday)
    6.times do |i| 
      @appointments[i] = Procedure.where(:date => (Date.today + i.days)).includes(:dentist)
    end

    6.times do |i| 
      @dentists[i] = @appointments[i].collect { |j| j["dentist_id"] }.uniq
    end

    6.times do |i| 
      @production[i] = number_to_currency(@appointments[i].collect { |e| e["price"] }.reduce :+) || "$0.00"
    end
  end

  def load_chart_data
    @rev_chart_data  = format_rev_line_chart_data(
                         @rev.revenue_per(1.week, 10, DateTime.now - 10.weeks)
                       )
    @prod_chart_data = format_production_area_chart_data(
                         @rev.production_per(1.week, 10, (DateTime.now - 1.month).beginning_of_month)
                       )
  end
end