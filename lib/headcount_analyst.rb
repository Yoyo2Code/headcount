require 'pry'
require_relative 'district_repository'

class HeadcountAnalyst
  attr_reader :district_hash

  def initialize(district_repo)
    @district_hash = district_repo.district_collection
  end

  def kindergarten_participation_rate_variation(district1, district2)
    district1_average = find_average(district1, :kindergarten_participation)
    district2_name = district2[:against]
    district2_average = find_average(district2_name, :kindergarten_participation)

    truncate(district1_average / district2_average)
  end

  def graduation_rate_variation(district1, district2)
    district1_average = find_average(district1, :high_school_graduation)
    district2_name = district2[:against]
    district2_average = find_average(district2_name, :high_school_graduation)

    truncate(district1_average / district2_average)
  end

  def find_average(district_name, grade_level)
    participation = participation_rates_per_year(district_name, grade_level)
    participation_sum = participation.values.reduce(0, :+)
    participation_average = participation_sum / participation.keys.count
  end

  def participation_rates_per_year(district_name, grade_level)
    district_hash[district_name].enrollment.enrollment_data[grade_level]
  end

  def kindergarten_participation_rate_variation_trend(district1, district2)
    original = participation_rates_per_year(district1, :kindergarten_participation).sort.to_h
    comparison = participation_rates_per_year(district2[:against], :kindergarten_participation).sort.to_h

    calculate_annual_variations(original, comparison)
  end

  def calculate_annual_variations(original, comparison)
    result = {}
    # binding.pry
    original.each_key do |key|
      result[key] = truncate(original[key] / comparison[key])
    end
    result
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
    kindergarten_variation = kindergarten_participation_rate_variation(district_name, :against=>'COLORADO')
    graduation_variation = graduation_rate_variation(district_name, :against=>'COLORADO')

    truncate(kindergarten_variation / graduation_variation)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(name)
  end

  def truncate(number)
    number.to_s[0..4].to_f
  end
end
