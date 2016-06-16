require 'minitest/autorun'
require 'minitest/pride'
require './lib/statewide_test_repository'
require 'pry'

class StatewideTestRepositoryTest < Minitest::Test

  def test_loading_statewide_test_data
    str = StatewideTestRepository.new
      str.load_data({
        :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
        }
      })

      assert_instance_of StatewideTest, str.statewide_test_repository.first
  end

  def test_find_by_district_name
    str = StatewideTestRepository.new
      str.load_data({
        :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
        }
      })
      result = str.find_by_name("ACADEMY 20")
      assert_equal "ACADEMY 20", result.name
  end

  def test_find_by_unknown_name_returns_nil
    str = StatewideTestRepository.new
      str.load_data({
        :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
        }
      })
      result = str.find_by_name("PIZZA PIZZA")
      assert_equal nil, result
  end
end
