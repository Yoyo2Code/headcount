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
        build_repo(grade_repo, key)
      elsif key === :math || key == :reading || key == :writing
        group_ethnicity_repo(contents, key)
      end
    end
  end

    def build_repo(testing_data_by_district, key)
      @statewide_test_repository = testing_data_by_district.map do |district|
        StatewideTest.new(key district)
      end
    end

    def group_grade_repo(contents)
      district_years = contents.sort_by do |contents|
        contents[:timeframe]
      end
        districts = district_years.map do |district|
          name = district[:location]
          subject = district[:score].to_sym
          data = truncate(district[:data].to_f)
          year = district[:timeframe].to_i
            {name: name, year => {subject => data}}
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

    def group_ethnicity_repo(contents, key)
      district_years = contents.sort_by do |contents|
        contents[:timeframe]
      end
        csv_data = district_years.map do |something|
          ethnicity = something[:race_ethnicity]
          name = something[:location]
          data = truncate(something[:data].to_f)
          year = something[:timeframe].to_i
            {name: name, race: ethnicity, year => data}
          end
          districts_by_name = csv_data.group_by do |contents|
            contents[:name]
          end
            districts_by_name.map do |name, data|
              by_race = data.group_by do |race_data|
                race_data[:race]
            end
              final_race_data = by_race.map do |name_of_race, race_data|
                  data_by_race = race_data.each do |district_data|
                    district_data.delete(:name)
                    district_data.delete(:race)
                  end.reduce({}, :merge)
                    symbol = name_of_race.split("/").last.gsub(/\s+/,"_").downcase.to_sym
                    {symbol => data_by_race}
              end
                  {name: name, race: final_race_data }
            end
          binding.pry
    end

    def truncate(number)
      number.to_s[0..4].to_f
    end
  end
