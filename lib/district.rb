require 'pry'
require_relative 'enrollment'

class District
  attr_accessor :name, :enrollment

  def initialize(district)
    @name = district[:name].upcase
    @enrollment = nil
  end

  # def name
  #   @district[:name].upcase
  # end
end
