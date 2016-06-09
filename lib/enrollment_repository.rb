require 'pp'
require 'pry'
require 'csv'

class EnrollmentRepository

  def load_data(file_tree)
    file = file_tree[:enrollment][:kindergarten]
    contents = CSV.read file, headers: true, header_converters: :symbol
    stuff = contents.map do |row|
      {:name => row[:location],
      row[:timeframe].to_i =>
      row[:data].to_f }
    end
    group_by_district(stuff)
  end

  def group_by_district(years)
    group_names = years.group_by do |row|
      row[:name]
  end
  collection = group_names.map do |name,years|
    merged = years.reduce({}, :merge)
    merged.delete(:name)
    { name: name,
      kindergarten_participation: merged }
    end
    # binding.pry
  end

  def find_by_name(name)
    
  end
end
