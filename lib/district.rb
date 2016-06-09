require 'pry'

class District
  attr_reader :district

  def initialize(district)
    @district = district
    # binding.pry
  end

  def name
    @district[:name].upcase
  end

end
