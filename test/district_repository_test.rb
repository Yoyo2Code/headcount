require_relative 'test_helper'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  def test_instance_of_district_repository
    dr = DistrictRepository.new
    assert_instance_of DistrictRepository, dr
  end

  def test_load_district_repo_data
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    result = {:name => "Colorado"}
    assert_equal result, dr.collection[0].district
  end

  def test_district_repo_find_by_name
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", district.name
  end

  def test_district_repo_find_by_lowercase_name
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    district = dr.find_by_name("Colorado")
    assert_equal "COLORADO", district.name
  end

  def test_district_repo_find_by_mixed_case_name
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    district = dr.find_by_name("coLoRAdO")
    assert_equal "COLORADO", district.name
  end

  def test_district_repo_find_by_unknown_name_returns_nil
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

  def test_find_all_matching_lowercase_name_fragment
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    district_array = dr.find_all_matching("colo")
    assert_equal ["COLORADO", "COLORADO SPRINGS 11"], district_array
  end

  def test_find_all_matching_mixed_case_name_fragment
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
end
