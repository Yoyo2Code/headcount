require_relative 'test_helper'
require_relative '../lib/economic_profile'

class EconomicProfileTest < Minitest::Test
  def test_instance_of_economic_profile
       ec = make_economic_profile
       assert_instance_of EconomicProfile, ec
  end

  def test_find_household_income_in_years
    ep = make_economic_profile
    query = ep.median_household_income_in_year(2008)
    result = 55000
    assert_equal result, query
  end

  def test_median_household_income_average
    ep = make_economic_profile
    income_average = ep.median_household_income_average
    result = 55000
    assert_equal result, income_average
  end

  def test_children_in_poverty_search
    ep     = make_economic_profile
    query  = ep.children_in_poverty_in_year(2012)
    result = 0.1845
    assert_equal result, query
  end

  def test_find_household_income_in_years
    ep     = make_economic_profile
    query  = ep.free_or_reduced_price_lunch_percentage_in_year(2014)
    result = 100
    assert_equal result, query
  end

  def test_title_i_in_year_percentage
    ec      = make_economic_profile
    command = ec.title_i_in_year(2015)
    result = 0.543
    assert_equal result, command
  end

  def data
     {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
      :children_in_poverty => {2012 => 0.1845},
      :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
      :title_i => {2015 => 0.543},
      :name => "ACADEMY 20"
     }
  end

  def make_economic_profile
    EconomicProfile.new(data)
  end
end
