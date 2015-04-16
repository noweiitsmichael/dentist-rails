require "time"

class PracticesController < ApplicationController
  include ActionView::Helpers::NumberHelper
  include PracticesHelper

  before_filter :set_practice

  def index
    @revenue_data = Hyda::Revenue.new(1)
    @appointments = []
    @dentists = []
    @production = []

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



    # charts
    rev = Hyda::Revenue.new(@practice)

    js :rev_hist   => format_rev_line_chart_data(
                        rev.revenue_per(1.week, 10, DateTime.now - 10.weeks)
                      )
    js :production => format_production_area_chart_data(
                        rev.production_per(1.week, 10, (DateTime.now - 1.month).beginning_of_month)
                      )
  end

  private

  def set_practice
    @practice = Practice.find(1)
  end
end