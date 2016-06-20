require 'pry'

class EconomicProfile
  attr_reader :profile_data

  def initialize(profile_data)
    @profile_data = profile_data
  end

  def household_income
    profile_data[:median_household_income]
  end

  def children_poverty
    profile_data[:children_in_poverty]
  end

  def lunch_data
    profile_data[:free_or_reduced_price_lunch]
  end

  def find_year_data(wanted_year)
    result = household_income.map do |years, amount|
      x = years.first
      y = years.last
      wanted_year.between?(x,y) ? amount : nil
    end.compact
    calculate_sum(result)/result.count
  end

  def median_household_income_in_year(year)
    result = find_year_data(year)
    result == [] ? raise(UknownDataError) : result
    #need work
  end

  def children_in_poverty_in_year(year)
    result = children_poverty.find do |data|
      data.first == year
    end
    result.last
  end

  def free_or_reduced_price_lunch_percentage_in_year(year_input)
    result = lunch_data.find do |year, data|
      year == year_input
    end
    result.last[:total]
  end

  def calculate_sum(data)
    data.inject(0) do |result, num|
      result + num
    end
  end

  def median_household_income_average
    total_years = 0
    total = 0
    profile_data[:median_household_income].each do |years, data|
      total_years += 1 if years != nil
      total += data
    end
    total/total_years
  end

  def title_i_in_year(year_search)
    r = profile_data[:title_i].find do |d|
          d.first == year_search
    end
    r.last
  end
end
