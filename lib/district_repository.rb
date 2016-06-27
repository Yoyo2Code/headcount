require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require 'pry'
require 'csv'

class DistrictRepository
  attr_reader :statewide_test_repo
  attr_accessor :district_collection

  def initialize
    @district_collection = {}
    @enrollment_repo = EnrollmentRepository.new
    @statewide_test_repo = StatewideTestRepository.new
  end

  def load_data(file_tree)
    file_tree.each do |file|
      create_enrollment_repo(file_tree)     if file[0] == :enrollment
      create_statewide_test_repo(file_tree) if file[0] == :statewide_testing
      repo_with_districts(file)
    end
  end

  def repo_with_districts(file)
    @enrollment_repo.enrollment_collection.each_key do |district_name|
      enrollment_object = @enrollment_repo.find_by_name(district_name)
      statewide_object  = @statewide_test_repo.find_by_name(district_name)
      objects           = [district_name, enrollment_object]
      district_data     = district_with_enrollment(objects)
      if file[0] == :statewide_testing
        district_data[:statewide_testing] = statewide_object
      end
        create_district_and_collection(district_data,district_name)
    end
  end

  def create_district_and_collection(district_data,district_name)
    district = District.new(district_data)
    @district_collection[district_name] = district
  end

  def district_with_enrollment(objects)
    { :name => objects.first, :enrollment => objects.last }
  end

  def create_enrollment_repo(file_tree)
    @enrollment_repo.load_data({ :enrollment => file_tree[:enrollment] })
  end

  def create_statewide_test_repo(file_tree)
    @statewide_test_repo.load_data({ :statewide_testing => file_tree[:statewide_testing] })
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
