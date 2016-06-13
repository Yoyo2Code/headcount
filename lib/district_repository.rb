require 'pp'
require 'pry'
require 'csv'
require_relative 'district'


class DistrictRepository
  attr_reader :collection

  def initialize
    @collection = []
  end

  def load_data(file_tree)
    file = file_tree[:enrollment][:kindergarten]
    contents = CSV.read file, headers: true, header_converters: :symbol
    districts_repo = contents.map do |row|
      { :name => row[:location] }
    end
    districts = districts_repo.uniq
    @collection = districts.map do |district|
      District.new(district)
    end
  end

  def group_by_district(districts)
    group_names = districts.group_by do |row|
      row[:name]
    end
  end

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
