require 'pry'
require_relative 'enrollment'

class District
  attr_reader :name
  attr_accessor :enrollment

  def initialize(district)
    @name = district[:name].upcase
    @enrollment = district[:enrollment]
  end
  
end
