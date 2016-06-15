require './lib/statewide_test'
require 'pp'
require 'csv'
require 'pry'

class StatewideTestRepository
  attr_reader :statewide_test_repository

  def load_data(file_tree)
    if file_tree.has_key?(:statewide_testing)
      load_path(file_tree[:statewide_testing])
    end
  end

    def load_path(data_file)
      data_file.map do |key,file|
      contents = CSV.read file, headers: true, header_converters: :symbol
      if key == :third_grade || key == :eighth_grade
        grade_repo = group_grade_repo(contents)
        build_repo(grade_repo)
      elsif key === :math || key == :reading || key == :writing
        binding.pry
        group_ethnicity_repo(contents)
      end
    end
  end

    def build_repo(testing_data_by_district)
      @statewide_test_repository = testing_data_by_district.map do |district|
        StatewideTest.new(district)
      end
    end

    def group_grade_repo(contents)
      district_years = contents.sort_by do |contents|
        contents[:timeframe]
      end
        districts = district_years.map do |district|
          name = district[:location]
          subject = district[:score]
          data = truncate(district[:data].to_f)
          year = district[:timeframe].to_i
            {name: name, year => {subject.to_sym => data}}
        end
          districts_by_name = districts.group_by do |contents|
            contents[:name]
          end
            district_testing_data = districts_by_name.map do |name, data|
              data_without_name = data.each do |information|
                information.delete(:name)
                information
              end
                grouped_by_years = data_without_name.group_by do |scores|
                  scores.keys.first
                end
              subjects_with_year = grouped_by_years.map do |year, yearly_data|
                subject_data = yearly_data.map do |today|
                  today.values.first
                end.reduce({}, :merge).sort.to_h
                {year => subject_data}
              end.reduce({}, :merge)
              {name: name, testing_data: subjects_with_year}
          end
          # binding.pry
    end

    def group_ethnicity_repo(contents)
      contents.group_by do |search|
        search[:Race_Ethnicity]
      end
      binding.pry
    end

    def truncate(number)
      number.to_s[0..4].to_f
    end

    def proficient_by_grade(grade)

    end

    def bad_data?(district)

    end
  end
