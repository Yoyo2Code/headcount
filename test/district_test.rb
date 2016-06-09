require_relative 'test_helper'
require './lib/district'

class DistrictTest < Minitest::Test

  def test_district_name
    d = District.new({:name => "ACADEMY 20"})#
    result = d.name
    assert_equal "ACADEMY 20", result
  end

  def test_district_name_upcased
    d = District.new({:name => "academy 20"})#
    result = d.name
    assert_equal "ACADEMY 20", result
  end

  def test_camel_cased_district_name
    d = District.new({:name => "AcAdEmY 20"})#
    result = d.name
    assert_equal "ACADEMY 20", result
  end
end


# name - returns the upcased string name of the district
# We create an instance like this:
