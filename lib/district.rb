require 'pry'

class District
  # attr_reader

  def initialize(district)
    @district = district
    # binding.pry
  end

  def name
    @district[:name].upcase
  end

end
