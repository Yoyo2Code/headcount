require_relative 'test_helper'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def test_instance_of_enrollment_repository
    er = EnrollmentRepository.new
    assert_instance_of EnrollmentRepository, er
  end

  def test_load_enrollment_repo_data
    er = EnrollmentRepository.new
    enrollments = er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    result = {
              :name=>"Colorado",
              :kindergarten_participation=>
               {2007=>0.39465,
                2006=>0.33677,
                2005=>0.27807,
                2004=>0.24014,
                2008=>0.5357,
                2009=>0.598,
                2010=>0.64019,
                2011=>0.672,
                2012=>0.695,
                2013=>0.70263,
                2014=>0.74118}
              }
    assert_equal result, enrollments[0].enrollment_data
  end

  def test_enrollment_repo_find_by_name
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    result = {
              :name=>"Colorado",
              :kindergarten_participation=>
               {2007=>0.39465,
                2006=>0.33677,
                2005=>0.27807,
                2004=>0.24014,
                2008=>0.5357,
                2009=>0.598,
                2010=>0.64019,
                2011=>0.672,
                2012=>0.695,
                2013=>0.70263,
                2014=>0.74118}
              }
    enrollment_object = er.find_by_name("Colorado")
    assert_equal result, enrollment_object.enrollment_data
  end
end
