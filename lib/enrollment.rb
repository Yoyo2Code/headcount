require 'pry'

class Enrollment
  attr_accessor :name, :enrollment_data

  def initialize(information)
    @name = information[:name].upcase
    @enrollment_data = information
  end

  def kindergarten_participation_by_year
    participation_data = @enrollment_data[:kindergarten_participation]
    hash = participation_data.map do |year, rate|
      { year => truncate(rate) }
    end.reduce({}, :merge)
    hash.sort.to_h
  end

  def kindergarten_participation_in_year(year)
    enrollment_participation = kindergarten_participation_by_year
    enrollment_participation[year]
  end

  def graduation_rate_by_year
    participation_data = @enrollment_data[:high_school_graduation]
    hash = participation_data.map do |year, rate|
      { year => truncate(rate) }
    end.reduce({}, :merge)
    hash.sort.to_h
  end

  def graduation_rate_in_year(year)
    enrollment_participation = graduation_rate_by_year
    enrollment_participation[year]
  end

  def truncate(number)
    number.to_s[0..4].to_f
  end

  def input_enrollment_data(inputted_data)
    @enrollment_data.merge!(inputted_data)
  end
end
