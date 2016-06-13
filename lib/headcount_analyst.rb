require 'pry'
require_relative 'district_repository'

class HeadcountAnalyst
  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district1, district2)
    district1_average = find_average(district1)
    district2_name = district2[:against]
    district2_average = find_average(district2_name)

    (district1_average / district2_average).round(3)
  end

  def find_average(district_name)
    district_info = district_repo.find_by_name(district_name).enrollment.enrollment_data
    participation = district_info[:kindergarten_participation]
    participation_sum = participation.values.reduce(0, :+)
    participation_average = participation_sum / participation.keys.count
  end
end
