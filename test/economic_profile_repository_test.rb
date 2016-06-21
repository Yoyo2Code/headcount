require_relative 'test_helper'
require_relative '../lib/economic_profile_repository'
require_relative '../lib/economic_profile'
require_relative '../lib/data_loader'

class EconomicProfileRepositoryTest < Minitest::Test

  def test_instance
    epr = make_economic_repo
    assert epr.first.is_a?(EconomicProfile)
  end

  def test_repo_starts_empty
    epr = EconomicProfileRepository.new
    assert_equal [], epr.economic_repo
  end

  def test_loading_data
    ep = make_economic_repo
    result = ep.first
    assert result.is_a?(EconomicProfile)
  end

  def test_find_by_name
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })
    query = epr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", query.name
  end

  def make_economic_repo
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })
  end
end
