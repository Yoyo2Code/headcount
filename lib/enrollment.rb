require 'pry'

class Enrollment
  attr_reader :enrollment_data

  def initialize(information)
    @enrollment_data = information
  end

  def kindergarten_participation_by_year
    participation_data = @enrollment_data[:kindergarten_participation]
    participation_data.map do |year, rate|
      { year => truncate(rate) }
    end.reduce({}, :merge)
  end

  def truncate(number)
    number.to_s[0..4].to_f
  end

  def name
    @enrollment_data[:name].upcase
  end

  def kindergarten_participation_in_year(year)
    enrollment_participation = kindergarten_participation_by_year
    enrollment_participation[year]
  end
end
