require 'pp'
require 'pry'
require 'csv'
require_relative 'district'
require_relative 'enrollment_repository'


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
    # binding.pry
    enrollment_repo.enrollment_collection.each_key do |district_name|
      enrollment_object = enrollment_repo.find_by_name(district_name)
      district = District.new({ :name => district_name,
                                :enrollment => enrollment_object })
      @district_collection[district_name] = district
    end
  end

  def find_by_name(name)
    @district_collection[name.upcase]
    # @district_collection.detect do |enrollment_object|
    #   enrollment_object.name == name.upcase
    # end
  end

  def find_all_matching(name)
    matching_districts = @district_collection.select do |enrollment_object|
      enrollment_object.include?(name.upcase)
    end
    matching_districts.keys
  end

  #   file = file_tree[:enrollment][:kindergarten]
  #   contents = CSV.read file, headers: true, header_converters: :symbol
  #   build_repos(contents)
  # end

  # def build_repos(contents)
  #   create_district_repo(contents)
  #   @enrollment_repo.build_repo(contents)
  #   # binding.pry
  #   insert_enrollment_data
  # end
  #
  # def create_district_repo(contents)
  #   district_names = contents.map do |row|
  #     { :name => row[:location] }
  #   end
  #   districts = district_names.uniq
  #   @district_collection = districts.map do |district|
  #     District.new(district)
  #   end
  # end
  #
  # def insert_enrollment_data
  #   @district_collection.each do |district|
  #     district.enrollment = @enrollment_repo.find_by_name(district.name)
  #   end
  # end
end
