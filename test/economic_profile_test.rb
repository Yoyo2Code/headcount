require 'minitest/autorun'
require 'minitest/pride'
require './lib/economic_profile'
require 'pry'

class EconomicProfileTest < Minitest::Test
  def test_instance_of_economic_profile
    # skip
        data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
            :children_in_poverty => {2012 => 0.1845},
            :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
            :title_i => {2015 => 0.543},
            :name => "ACADEMY 20"
           }
       ec = EconomicProfile.new(data)
       assert_instance_of EconomicProfile, ec
  end

  def test_find_household_income_in_years
    ep = make_economic_profile
    query = ep.median_household_income_in_year(2008)
    result = 55000
    assert_equal result, query
  end

  def make_economic_profile
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
       economic_profile = EconomicProfile.new(data)
  end

  def test_find_household_income_in_years
    ep     = make_economic_profile
    query  = ep.children_in_poverty_in_year(2012)
    result = 0.1845
    assert_equal result, query
  end

  def test_find_household_income_in_years
    ep     = make_economic_profile
    query  = ep.free_or_reduced_price_lunch_percentage_in_year(2014)
    result = 0.1845
    assert_equal result, query
  end
end
