require 'pp'
require 'pry'
require 'csv'
require_relative 'enrollment'

class EnrollmentRepository

  def initialize
    @collection = []
  end

  def load_data(file_tree)
    file = file_tree[:enrollment][:kindergarten]
    contents = CSV.read file, headers: true, header_converters: :symbol
    build_repo(contents)
    # enrollments = contents.map do |row|
    #   { :name => row[:location],
    #     row[:timeframe].to_i => row[:data].to_f }
    # end
    # group_by_district(enrollments)
  end

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
    @collection = districts_by_name.map do |key,value|
      merged = value.reduce({}, :merge)
      merged.delete(:name)
      Enrollment.new({ name: key, kindergarten_participation: merged })
    end
  end

  def find_by_name(name)
    @collection.detect do |enrollment_object|
      enrollment_object.name == name.upcase
    end
  end
end
