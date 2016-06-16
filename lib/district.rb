require_relative 'enrollment'
require 'pry'

class District
  attr_reader :name, :statewide_test
  attr_accessor :enrollment

  def initialize(district)
    @name = district[:name].upcase
    @enrollment = district[:enrollment]
    @statewide_test = district[:statewide_testing]
  end
end
