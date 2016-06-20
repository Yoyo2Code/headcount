require_relative 'test_helper'
require_relative '../lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test
  attr_reader :result

  def setup
    @result = {
              :name=>"COLORADO",
              :kindergarten_participation=>{ 2007=>0.39465,
                                             2006=>0.33677,
                                             2005=>0.27807,
                                             2004=>0.24014,
                                             2008=>0.5357,
                                             2009=>0.598,
                                             2010=>0.64019,
                                             2011=>0.672,
                                             2012=>0.695,
                                             2013=>0.70263,
                                             2014=>0.74118 },
              :high_school_graduation=>{ 2010=>0.724,
                                         2011=>0.739,
                                         2012=>0.75354,
                                         2013=>0.769,
                                         2014=>0.773 }
              }
  end

  def test_instance_of_enrollment_repository
    er = EnrollmentRepository.new
    assert_instance_of EnrollmentRepository, er
  end

  def test_can_load_enrollment_repository_data
    er = EnrollmentRepository.new
    enrollments = er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    assert_equal result[:kindergarten_participation], enrollments["COLORADO"]
  end

  def test_can_load_enrollment_repository_data_for_multiple_files
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    enrollment_object = er.find_by_name("ACADEMY 20")
    result1 = {
                2010 => 0.895,
                2011 => 0.895,
                2012 => 0.88983,
                2013 => 0.91373,
                2014 => 0.898
               }

    result2 = {
                2007 => 0.39159,
                2006 => 0.35364,
                2005 => 0.26709,
                2004 => 0.30201,
                2008 => 0.38456,
                2009 => 0.39,
                2010 => 0.43628,
                2011 => 0.489,
                2012 => 0.47883,
                2013 => 0.48774,
                2014 => 0.49022
               }
    data1 = enrollment_object.enrollment_data[:high_school_graduation]
    data2 = enrollment_object.enrollment_data[:kindergarten_participation]

    assert_equal result1, data1
    assert_equal result2, data2
  end

  def test_find_by_name
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    enrollment_object = er.find_by_name("Colorado")
    assert_equal result, enrollment_object.enrollment_data
  end

  def test_find_by_name_is_case_insensitive
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    enrollment_object = er.find_by_name("cOLoRaDo")
    assert_equal result, enrollment_object.enrollment_data
  end
end
