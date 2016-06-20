require_relative 'enrollment'
require 'pry'

class District
  attr_reader :name
  attr_accessor :enrollment,
                :economic_profile

  def initialize(district)
    @name = district[:name].upcase
    @enrollment = district[:enrollment]
    @economic_profile = district[:economic_profile]
  end
end
