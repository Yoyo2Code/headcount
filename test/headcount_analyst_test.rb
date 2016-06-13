require_relative 'test_helper'
require './lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test

  def test_it_initializes_with_a_district_repository
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert_instance_of DistrictRepository, ha.district_repo
  end

  def test_compare_average_participation_between_districts
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)

    comparison = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    assert_equal 0.766, comparison

    comparison = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
    assert_equal 0.447, comparison
  end
end
