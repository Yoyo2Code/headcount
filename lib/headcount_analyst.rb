require 'pry'
require_relative 'district_repository'

class HeadcountAnalyst
  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district1, district2)
    district1_average = find_average(district1)
    district2_name = district2[:against]
    district2_average = find_average(district2_name)

    (district1_average / district2_average).round(3)
  end

  def find_average(district_name)
    participation = participation_rates_per_year(district_name)
    participation_sum = participation.values.reduce(0, :+)
    participation_average = participation_sum / participation.keys.count
  end

  def participation_rates_per_year(district_name)
    district_repo.find_by_name(district_name).enrollment.enrollment_data[:kindergarten_participation]
  end

  def kindergarten_participation_rate_variation_trend(district1, district2)
    original = participation_rates_per_year(district1).sort.to_h
    comparison = participation_rates_per_year(district2[:against]).sort.to_h
    calculate_annual_variations(original, comparison)
  end

  def calculate_annual_variations(original, comparison)
    result = {}
    # binding.pry
    original.each_key do |key|
      result[key] = (original[key] / comparison[key]).to_s[0..4].to_f
    end
    result
  end
end
