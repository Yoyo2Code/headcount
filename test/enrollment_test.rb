require_relative 'test_helper'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test

  def test_instance_of_enrollment
    e = Enrollment.new({
      :name => "ACADEMY 20",
      :kindergarten_participation => { 2010 => 0.3915,
                                       2011 => 0.35356,
                                       2012 => 0.2677 }
      })
    assert_instance_of Enrollment, e
  end

  def test_kindergarten_participation_by_year
    e = Enrollment.new({
      :name => "ACADEMY 20",
      :kindergarten_participation => { 2010 => 0.3915,
                                       2011 => 0.35356,
                                       2012 => 0.2677 }
      })
    data = e.kindergarten_participation_by_year
    result = { 2010 => 0.391,
               2011 => 0.353,
               2012 => 0.267
              }
    assert_equal result, data
  end

  def test_kindergarten_participation_in_year
    e = Enrollment.new({
      :name => "ACADEMY 20",
      :kindergarten_participation => { 2010 => 0.3915,
                                       2011 => 0.35356,
                                       2012 => 0.2677 }
      })
    result = 0.391
    assert_equal result, e.kindergarten_participation_in_year(2010)
  end

  def test_kindergarten_participation_by_unknown_year_returns_nil
    e = Enrollment.new({
      :name => "ACADEMY 20",
      :kindergarten_participation => { 2010 => 0.3915,
                                       2011 => 0.35356,
                                       2012 => 0.2677 }
      })
    result = nil
    assert_equal result, e.kindergarten_participation_in_year(1987)
  end

  def test_graduation_rate_by_year
    e = Enrollment.new({
      :name => "ACADEMY 20",
      :kindergarten_participation => { 2010 => 0.3915,
                                       2011 => 0.35356,
                                       2012 => 0.2677 },
      :high_school_graduation => { 2010 => 0.895,
                                   2011 => 0.895,
                                   2012 => 0.889,
                                   2013 => 0.913,
                                   2014 => 0.898 }
      })
    data = e.graduation_rate_by_year
    result = { 2010 => 0.895,
               2011 => 0.895,
               2012 => 0.889,
               2013 => 0.913,
               2014 => 0.898
              }
    assert_equal result, data
  end
end
