require 'pp'
require 'pry'
require 'csv'
require_relative 'enrollment'

class EnrollmentRepository

  def initialize
    @collection = []
  end

  def load_data(file_tree)
    # binding.pry
    file_tree[:enrollment].each do |key, value|
    # end
    # file = file_tree[:enrollment][:kindergarten]
      contents = CSV.read value, headers: true, header_converters: :symbol
      build_repo(contents)
    end
    # enrollments = contents.map do |row|
    #   { :name => row[:location],
    #     row[:timeframe].to_i => row[:data].to_f }
    # end
    # group_by_district(enrollments)
  end

  # def load_kinder_data(file_tree)

  def build_repo(contents)
    enrollments = contents.map do |row|
      { :name => row[:location],
        row[:timeframe].to_i => row[:data].to_f }
    end
    group_by_district(enrollments)
  end

  def group_by_district(enrollments)
    districts_by_name = enrollments.group_by do |row|
      row[:name]
    end
    if @collection.empty?
      @collection = districts_by_name.map do |key,value|
        # binding.pry
        merged = value.reduce({}, :merge)
        merged.delete(:name)
        Enrollment.new({ name: key, kindergarten_participation: merged })
      end
    else
      districts_by_name.each do |key,value|
        binding.pry
        merged = value.reduce({}, :merge)
        name = value[:name]
        merged.delete(:name)
        # if name ==
      end
      #if not, get data, then add high school data through each collection (each enrollment)
     end
   end

  def find_by_name(name)
    @collection.detect do |enrollment_object|
      enrollment_object.name == name.upcase
    end
  end
end
