require 'pp'
require 'pry'
require 'csv'
require_relative 'district'


class DistrictRepository
  attr_reader :collection

  # def load_data(hash_path)
  #   filepath = hash_path[:enrollment][:kindergarten]
  #   CSV.foreach(filepath), headers: true, header_converters: :symbol.map do |row|
  #     {name: row[:location], row[:timeframe].to_i => row[:data].to_f}
  # end

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
    # @collection = group_names.map do |name,years|
    #   merged = years.reduce({}, :merge)
    #   merged.delete(:name)
    #   District.new({ name: name, kindergarten_participation: merged })
    # end
  end

  def find_by_name(name)
    @collection.detect do |enrollment_object|
      enrollment_object.name == name
    end
  end
end
