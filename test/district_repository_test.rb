require_relative 'test_helper'
require './lib/district_repository'
require './lib/enrollment'

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

  def test_load_data_creates_state_test_repo_with_state_test_data
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    statewide_test = district.statewide_test

    result = { :all_students => { 2011=>0.68,
                                  2012=>0.689,
                                  2013=>0.696,
                                  2014=>0.699 },
               :asian => { 2011=>0.816,
                           2012=>0.818,
                           2013=>0.805,
                           2014=>0.8 },
               :black => { 2011=>0.424,
                           2012=>0.424,
                           2013=>0.44,
                           2014=>0.42 },
               :pacific_islander => { 2011=>0.568,
                                      2012=>0.571,
                                      2013=>0.683,
                                      2014=>0.681 },
               :hispanic => { 2011=>0.568,
                              2012=>0.572,
                              2013=>0.588,
                              2014=>0.604 },
               :native_american => { 2011=>0.614,
                                     2012=>0.571,
                                     2013=>0.593,
                                     2014=>0.543 },
               :two_or_more => { 2011=>0.677,
                                 2012=>0.689,
                                 2013=>0.696,
                                 2014=>0.693 },
               :white => { 2011=>0.706,
                           2012=>0.713,
                           2013=>0.72,
                           2014=>0.723 }}

    assert_equal result, statewide_test.math
  end
end
