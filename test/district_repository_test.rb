require_relative 'test_helper'
require_relative '../lib/district_repository'
require_relative '../lib/enrollment'

class DistrictRepositoryTest < Minitest::Test

  def test_instance_of_district_repository
    dr = DistrictRepository.new
    assert_instance_of DistrictRepository, dr
  end

  def test_can_load_district_repo_data
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    assert_equal 181, dr.district_collection.count
  end

  def test_find_by_name
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", district.name
  end

  def test_find_by_name_is_case_insensitive
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    district = dr.find_by_name("coLoRAdO")
    assert_equal "COLORADO", district.name
  end

  def test_find_by_unknown_name_returns_nil
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    district = dr.find_by_name("PIZZA")
    assert_equal nil, district
  end

  def test_find_all_matching_using_name_fragment
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    district_array = dr.find_all_matching("COLO")
    assert_equal ["COLORADO", "COLORADO SPRINGS 11"], district_array
  end

  def test_find_all_matching_is_case_insensitive
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    district_array = dr.find_all_matching("CoLo")
    assert_equal ["COLORADO", "COLORADO SPRINGS 11"], district_array
  end

  def test_find_all_matching_empty_array_if_no_matches_found
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    district_array = dr.find_all_matching("piz")
    assert_equal [], district_array
  end

  def test_load_data_creates_enrollment_repo_with_enrollment_data
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    assert_equal 0.436, district.enrollment.kindergarten_participation_in_year(2010)
  end
end
