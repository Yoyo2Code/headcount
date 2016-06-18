require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require 'pry'
require 'csv'

class DistrictRepository
  attr_accessor :district_collection

  def initialize
    @district_collection = {}
  end

# some fun stuff

  def load_data(file_tree)
    @enrollment_repo = EnrollmentRepository.new
    @statewide_test_repo = StatewideTestRepository.new
    file_tree.each do |file|
      if file[0] == :enrollment
        @enrollment_repo.load_data({ :enrollment => file_tree[:enrollment] })
      elsif file[0] == :statewide_testing
        @statewide_test_repo.load_data({ :statewide_testing => file_tree[:statewide_testing] })
      end
      @enrollment_repo.enrollment_collection.each_key do |district_name|
        enrollment_object = @enrollment_repo.find_by_name(district_name)
        statewide_testing_object = @statewide_test_repo.find_by_name(district_name)
        district_data = { :name => district_name,
                          :enrollment => enrollment_object
                        }
        if file[0] == :statewide_testing
          district_data[:statewide_testing] = statewide_testing_object
        end
        district = District.new(district_data)
        @district_collection[district_name] = district
      end
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
