require_relative 'test_helper'
require './lib/district'

class DistrictTest < Minitest::Test

  def test_name_returns_district_name
    d = District.new({:name => "ACADEMY 20"})
    result = d.name
    assert_equal "ACADEMY 20", result
  end

  def test_lowercase_name_returns_district_name
    d = District.new({:name => "academy 20"})
    result = d.name
    assert_equal "ACADEMY 20", result
  end

  def test_mixed_case_name_returns_district_name
    d = District.new({:name => "AcAdEmY 20"})
    result = d.name
    assert_equal "ACADEMY 20", result
  end
end
