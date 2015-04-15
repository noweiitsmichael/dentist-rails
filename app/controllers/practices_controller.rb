require "Time"
require "pp"

class PracticesController < ApplicationController

  def index
    @appointments = []
    @dentists = []
    @production = []

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