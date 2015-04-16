require "Time"

class PracticesController < ApplicationController

  def index
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
      @production[i] = @appointments[i].collect { |e| e["price"] }.reduce :+
    end
  end

end