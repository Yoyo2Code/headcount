require_relative 'test_helper'
require_relative '../lib/district'

class DistrictTest < Minitest::Test

  def test_name_returns_district_name
    d = District.new({:name => "ACADEMY 20"})
    result = d.name
    assert_equal "ACADEMY 20", result
  end

  def test_name_is_case_insensitive
    d = District.new({:name => "aCAdEmY 20"})
    result = d.name
    assert_equal "ACADEMY 20", result
  end
end
