require 'pp'
require 'pry'
require 'csv'
require_relative 'district'
require_relative 'enrollment_repository'


class DistrictRepository
  attr_reader :collection, :enrollment_repo

  def initialize
    @collection = []
    @enrollment_repo = EnrollmentRepository.new
  end

  def load_data(file_path_hash)
    file = file_path_hash[:enrollment][:kindergarten]
    contents = CSV.read file, headers: true, header_converters: :symbol
    build_repos(contents)
    # district_names = contents.map do |row|
    #   { :name => row[:location] }
    # end
    # districts = district_names.uniq
    # @collection = districts.map do |district|
    #   District.new(district)
    # end
  end

  def build_repos(contents)
    create_district_repo(contents)
    @enrollment_repo.build_repo(contents)
    # binding.pry
    insert_enrollment_data
  end

  def create_district_repo(contents)
    district_names = contents.map do |row|
      { :name => row[:location] }
    end
    districts = district_names.uniq
    @collection = districts.map do |district|
      District.new(district)
    end
  end

  def insert_enrollment_data
    @collection.each do |district|
      district.enrollment = @enrollment_repo.find_by_name(district.name)
      binding.pry
    end
  end

  # def group_by_district(districts)
  #   districts.group_by do |row|
  #     row[:name]
  #   end
  # end

  def find_by_name(name)
    @collection.detect do |enrollment_object|
      enrollment_object.name == name.upcase
    end
  end

  def find_all_matching(name)
    matching_districts = @collection.select do |enrollment_object|
      enrollment_object.name.include?(name.upcase)
    end
    matching_districts.map do |district|
      district.name
    end
  end
end
