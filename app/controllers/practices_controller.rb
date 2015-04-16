class PracticesController < ApplicationController
  include ActionView::Helpers::NumberHelper
  include PracticesHelper

  before_filter :set_practice

  def index
    @rev = Hyda::Revenue.new(@practice)

    load_date_range
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

  def load_date_range
    @range = {}
    @range[:type] = params[:range].present? ? params[:range].to_sym : :this_month
    case @range[:type]
    when :this_month
      @range[:start_date] = DateTime.now.beginning_of_month
      @range[:end_date]   = DateTime.now.end_of_month
      @range[:interval]   = 1.month
    when :this_week
      @range[:start_date] = DateTime.now.beginning_of_week
      @range[:end_date]   = DateTime.now.end_of_week
      @range[:interval]   = 1.week
    when :last_week
      @range[:start_date] = (DateTime.now - 1.week).beginning_of_week
      @range[:end_date]   = (DateTime.now - 1.week).end_of_week
      @range[:interval]   = 1.week
    when :last_month
      @range[:start_date] = (DateTime.now - 1.month).beginning_of_month
      @range[:end_date]   = (DateTime.now - 1.month).end_of_month
      @range[:interval]   = 1.month
    else
      @range[:start_date] = DateTime.now.beginning_of_month
      @range[:end_date]   = DateTime.now.end_of_month
      @range[:interval]   = 1.month
    end
    @range[:to_s] = "#{@range[:start_date].strftime('%m/%d')} - #{@range[:end_date].strftime('%m/%d')}"
  end

  def load_summary_metrics
    @est_prod_this_mo = @rev.production_per(@range[:interval] , 1, @range[:start_date])[0][:total_price]
    @avg_rev_this_mo = @rev.avg_daily_revenue(@range[:start_date], @range[:end_date])
    @avg_ins_ratio_this_mo = @rev.insurance_collection_ratio(@range[:end_date] - 90.days, @range[:end_date])
    @new_patients_this_mo = @practice.patients.new_since(@range[:start_date]).count
  end

  def load_day_to_day
    ## TODO: change to 7 if we update to 7 days
    ## TODO: Start at beginning of week (Monday)
    @day_to_day = []
    6.times do |i|
      date = Date.today.beginning_of_week + i.days
      procs = Procedure.where(:date => (date)).includes(:dentist)

      @day_to_day.push({
        :date => date,
        :procs => procs,
        :dentists => procs.map(&:dentist).uniq
      })
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