require_relative 'enrollment_repository'
require_relative 'district'
require 'pp'
require 'pry'
require 'csv'


class DistrictRepository
  attr_accessor :district_collection

  def initialize
    @district_collection = {}
  end

  def load_data(file_tree)
    enrollment_repo = EnrollmentRepository.new
    if file_tree.has_key?(:enrollment)
      enrollment_repo.load_data({ :enrollment => file_tree[:enrollment] })
    end
    enrollment_repo.enrollment_collection.each_key do |district_name|
      enrollment_object = enrollment_repo.find_by_name(district_name)
      district = District.new({ :name => district_name,
                                :enrollment => enrollment_object })
      @district_collection[district_name] = district
    end
  end

  def find_by_name(name)
    @district_collection[name.upcase]
  end

  def find_all_matching(name)
    matching_districts = @district_collection.select do |enrollment_object|
      enrollment_object.include?(name.upcase)
    end
    matching_districts.keys
  end
end
