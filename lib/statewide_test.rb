require 'pry'

class StatewideTest
  attr_reader :test_data

  def initialize(test_data)
    @test_data = test_data
  end
end
