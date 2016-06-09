require 'pp'
require 'pry'
require 'csv'
require_relative 'enrollment'

class EnrollmentRepository
  # attr_accessor :collection

  def initialize
    @collection = []
  end

  def load_data(file_tree)
    file = file_tree[:enrollment][:kindergarten]
    contents = CSV.read file, headers: true, header_converters: :symbol
    enrollments = contents.map do |row|
      { :name => row[:location],
        row[:timeframe].to_i => row[:data].to_f }
    end
    group_by_district(enrollments)
  end

  def group_by_district(years)
    group_names = years.group_by do |row|
      row[:name]
    end
    @collection = group_names.map do |name,years|
      merged = years.reduce({}, :merge)
      merged.delete(:name)
      Enrollment.new({ name: name, kindergarten_participation: merged })
    end
  end

  def find_by_name(name)
    @collection.detect do |enrollment_object|
      enrollment_object.name == name
    end
  end

end
