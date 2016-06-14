require 'pp'
require 'pry'
require 'csv'
require_relative 'enrollment'

class EnrollmentRepository
  attr_accessor :enrollment_collection

  def initialize
    @enrollment_collection = {}
  end

  def load_data(file_tree)
    kindergarten_file = file_tree[:enrollment][:kindergarten]

    if file_tree[:enrollment][:high_school_graduation].nil? == false
      high_school_file = file_tree[:enrollment][:high_school_graduation]
      high_school_hashes = load_path(high_school_file)
    end

    kindergarten_hashes = load_path(kindergarten_file)

    kindergarten_hashes.each_key do |district_name|
      participation_hash = kindergarten_hashes[district_name]
      if high_school_hashes.nil? == false
        graduation_hash = high_school_hashes[district_name]
        enrollment = Enrollment.new({ :name => district_name,
                :kindergarten_participation => participation_hash,
                :high_school_graduation => graduation_hash })
      else
        enrollment = Enrollment.new({ :name => district_name,
                :kindergarten_participation => participation_hash })
      end
      @enrollment_collection[district_name] = enrollment
    end
  end

  def load_path(data_file)
    contents = CSV.read data_file, headers: true, header_converters: :symbol
    build_repo(contents)
  end

  def build_repo(contents)
    district_hashes = {}
    contents.each do |row|
      district_name = row[:location].upcase
      if district_hashes.has_key?(district_name) == false
        district_hashes[district_name] = {}
      end

      if row[:data] != "N/A"
        year = row[:timeframe].to_i
        rate = row[:data].to_f
        district_hashes.fetch(district_name)[year] = rate
      end
    end
    return district_hashes
  end

  def find_by_name(name)
    @enrollment_collection[name.upcase]
  end

  # def group_by_district(enrollments)
  #   districts_by_name = enrollments.group_by do |row|
  #     row[:name]
  #   end
  #   # binding.pry
  #   districts_by_name.each do |key,value|
  #     merged = value.reduce({}, :merge)
  #     merged.delete(:name)
  #     # binding.pry
  #     @enrollment_collection[key] = merged
  #     # Enrollment.new({ name: key, kindergarten_participation: merged })
  #   end
  #   # binding.pry
  # end

# enrollment_object.enrollment_data[:kindergarten_participation]

  # def find_by_name(name)
  #   # binding.pry
  #   @enrollment_collection.detect do |enrollment_object|
  #     enrollment_object.name == name.upcase
  #   end
  # end
end
