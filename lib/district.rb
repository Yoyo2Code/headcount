require_relative 'enrollment'
require 'pry'

class District
  attr_reader :name
  attr_accessor :enrollment

  def initialize(district)
    @name = district[:name].upcase
    @enrollment = nil
  end

  # def name
  #   @district[:name].upcase
  # end
end
