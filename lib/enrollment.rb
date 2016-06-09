require 'pry'

class Enrollment
  attr_reader :enrollment_data

  def initialize(information)
    @enrollment_data = information
  end

  def kindergarten_participation_by_year
    participation_data = @enrollment_data[:kindergarten_participation]
    participation_data.map do |year, data|
      {year => number_formatter(data)}
    end.reduce({}, :merge)
  end

  def number_formatter(number)
    number.to_s[0..4].to_f
  end

  def name
    @enrollment_data[:name]
  end

  def kindergarten_participation_in_year(year)
    enrollment_participation = kindergarten_participation_by_year
    enrollment_participation[year]
  end
end


# e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
