require_relative '../lib/statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test

  def test_loading_statewide_test_data
    str = StatewideTestRepository.new
      str.load_data({
        :statewide_testing => {
        # :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        # :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
        }
      })

      assert_equal 10, str
  end

  def test_finding_by_district_name
    skip
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
      str = str.find_by_name("ACADEMY 20")

      assert_instance_of StatewideTest, str
  end
end
