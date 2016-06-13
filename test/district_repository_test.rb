require_relative 'test_helper'
require './lib/district_repository'

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
    result = "COLORADO"
    assert_equal result, dr.collection[0].name
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

  def test_load_data_creates_enrollment_repo
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    assert_instance_of EnrollmentRepository, dr.enrollment_repo
  end

  def test_load_data_creates_enrollment_repo_with_enrollment_data
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    assert_equal 0.436, district.enrollment.kindergarten_participation_in_year(2010)
  end
end
