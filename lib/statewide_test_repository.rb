require_relative 'data_loader'
require 'pry'

class StatewideTestRepository
  attr_reader :statewide_test_objects

  def initialize
    @statewide_test_objects = {}
  end

  def load_data(file_tree)
    loader = DataLoader.new
    third_grade_hashes = loader.load_data(:testing_by_grade, file_tree[:statewide_testing][:third_grade])
  binding.pry
    eighth_grade_hashes = loader.load_data(:testing_by_grade, file_tree[:statewide_testing][:third_grade])
    math_by_ethnicity = loader.load_data(:ethnicity, file_tree[:statewide_testing][:math])
    reading_by_ethnicity = loader.load_data(:ethnicity, file_tree[:statewide_testing][:reading])
    writing_by_ethnicity = loader.load_data(:ethnicity, file_tree[:statewide_testing][:writing])
    third_grade_hashes.each_key do |district_name|
      statewide_test = StatewideTest.new({
            :name => district_name,
            :third_grade => third_grade_data[district_name],
            :eighth_grade => eighth_grade_data[district_name],
            :math => math_by_ethnicity[district_name],
            :reading => reading_by_ethnicity[district_name],
            :writing => writing_by_ethnicity[district_name]
        })
      statewide_test_objects[district_name] = statewide_test
    end
  end

  #   if file_tree[:enrollment][:high_school_graduation].nil? == false
  #     high_school_file = file_tree[:enrollment][:high_school_graduation]
  #     high_school_hashes = load_path(high_school_file)
  #   end
  #
  #   kindergarten_hashes = load_path(kindergarten_file)
  #
  #   kindergarten_hashes.each_key do |district_name|
  #     participation_hash = kindergarten_hashes[district_name]
  #     if high_school_hashes.nil? == false
  #       graduation_hash = high_school_hashes[district_name]
  #       enrollment = Enrollment.new({ :name => district_name,
  #               :kindergarten_participation => participation_hash,
  #               :high_school_graduation => graduation_hash })
  #     else
  #       enrollment = Enrollment.new({ :name => district_name,
  #               :kindergarten_participation => participation_hash })
  #     end
  #     @enrollment_collection[district_name] = enrollment
  #   end
  # end
  #
  # def load_path(data_file)
  #   contents = CSV.read data_file, headers: true, header_converters: :symbol
  #   build_repo(contents)
  # end
  #
  # def build_repo(contents)
  #   district_hashes = {}
  #   contents.each do |row|
  #     district_name = row[:location].upcase
  #     if district_hashes.has_key?(district_name) == false
  #       district_hashes[district_name] = {}
  #     end
  #       year = row[:timeframe].to_i
  #       rate = row[:data].to_f
  #       district_hashes.fetch(district_name)[year] = rate
  #     end
  #   return district_hashes
  # end
end
