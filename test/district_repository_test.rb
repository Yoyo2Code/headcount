require_relative 'test_helper'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  def test_instance_of_district_repository
    dr = DistrictRepository.new
    assert_instance_of DistrictRepository, dr
  end

  def test_load_district_repo_data
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    result = {:name => "Colorado"}
    # binding.pry
    assert_equal result, dr.collection[0].district
  end

end
