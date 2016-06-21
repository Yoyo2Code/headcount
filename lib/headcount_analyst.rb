require 'pry'
require_relative 'district_repository'

class HeadcountAnalyst
  attr_reader :district_hash

  def initialize(district_repo)
    @district_hash = district_repo.district_collection
    @statewide_repo = district_repo.statewide_test_repo
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
    original.each_key do |key|
      result[key] = truncate(original[key] / comparison[key])
    end
    result
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
    kg_variation = kindergarten_participation_rate_variation(district_name, :against=>'COLORADO')
    gd_variation = graduation_rate_variation(district_name, :against=>'COLORADO')

    truncate(kg_variation / gd_variation)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(name)
    if name.key?(:for)
      district_name = name[:for]
      if district_name == 'STATEWIDE'
        correlation_for_statewide
      else
        correlation_for_single_district(district_name)
      end

    else
      district_array = name[:across]
      correlation_across_districts(district_array)
    end
  end

  def correlation_for_statewide
    correlated = district_hash.keys.map do |district|
      kindergarten_participation_correlates_with_high_school_graduation(:for=>district) unless district == 'COLORADO'
    end
    correlated.compact.count / (district_hash.count - 1) > 0.7 ? true : false
  end

  def correlation_for_single_district(district_name)
    return true if kindergarten_participation_against_high_school_graduation(district_name).between?(0.6, 1.5)
  end

  def correlation_across_districts(district_array)
    correlated = district_array.map do |district|
      correlation_for_single_district(district)
    end
    correlated.compact.count / (district_array.count) > 0.7 ? true : false
  end

  def number_of_districts
    district_hash.count
  end

  def truncate(number)
    number.nan? == false ? number.to_s[0..4].to_f : 0
  end

  def top_statewide_test_year_over_year_growth(data)
    subject = data[:subject]
    grade = data[:grade]
    yoy = @district_hash.map do |name, districts|
      d = districts.statewide_test.eight_grade if grade == 8
      d = districts.statewide_test.third_grade if grade == 3
      improvement = test_stats(d, subject)
      [name, improvement]
    end
    yoy.sort_by do |name,improvement|
      improvement
    end.reverse
  end

  def test_stats(data, subject)
    total = 0
    yearly = nil
    r = data.each do |year,tests|
        now    = tests[subject]
        total += now - yearly if yearly != nil
        yearly = now
    end
    total
  end
end
