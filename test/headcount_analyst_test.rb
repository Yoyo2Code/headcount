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

    variation = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    assert_equal 0.766, variation

    variation = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
    assert_equal 0.447, variation
  end

  def test_compare_average_participation_between_districts_by_year
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)

    variation_trend = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
    result = {
               2004=>1.257,
               2005=>0.96,
               2006=>1.05,
               2007=>0.992,
               2008=>0.717,
               2009=>0.652,
               2010=>0.681,
               2011=>0.727,
               2012=>0.688,
               2013=>0.694,
               2014=>0.661
              }
    assert_equal result, variation_trend
  end
end
