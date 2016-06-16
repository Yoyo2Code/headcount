require_relative 'statewide_test'
require 'pp'
require 'csv'
require 'pry'

class StatewideTestRepository
  attr_accessor :statewide_test_repository

  def initialize
    @statewide_test_repository = {}
  end

  def load_data(file_tree)
    if file_tree.has_key?(:statewide_testing)
      load_path(file_tree[:statewide_testing])
    end
  end

  def load_path(data_file)
    data_file.each_pair do |key,file|
      contents = CSV.read file, headers: true, header_converters: :symbol
      if key == :third_grade
        @third_grade_repo = group_grade_repo(contents, key)
      elsif key == :eighth_grade
        @eighth_grade_repo = group_grade_repo(contents, key)
      elsif key === :math
        @math_repo = group_subject_repo(contents, key)
      elsif key == :reading
        @reading_repo = group_subject_repo(contents, key)
      elsif key == :writing
        @writing_repo = group_subject_repo(contents, key)
      end
    end

    combine_repos(@third_grade_repo, @eighth_grade_repo, @math_repo, @reading_repo, @writing_repo)
  end

  def combine_repos(repo1, repo2, repo3, repo4, repo5)
    combined_repo = repo1 + repo2 + repo3 + repo4 + repo5
    organized_repo = combined_repo.group_by do |hash|
      hash[:name]
    end
    final_repo = organized_repo.map do |name, value|
      nameless_data = value.each do |data|
        data.delete(:name)
        data
      end.reduce({}, :merge)
      {name: name}.merge(nameless_data)
    end
    build_repo(final_repo)
  end

  def build_repo(final_repo)
    @statewide_test_repository = final_repo.map do |district|
      StatewideTest.new(district)
    end
  end

  def sort_by_year(contents, key)
    contents.sort_by do |contents|
      contents[:timeframe]
    end
  end

  def sort_by_name(unsorted_data)
    unsorted_data.group_by do |contents|
      contents[:name]
    end
  end

  def group_grade_repo(contents, key)
    districts_by_year = sort_by_year(contents, key)
    all_district_data = districts_by_year.map do |district|
      name = district[:location]
      subject = district[:score]
      data = truncate(district[:data].to_f)
      year = district[:timeframe].to_i
      {name: name, year => {subject.to_sym => data}}
    end
    districts_by_name = sort_by_name(all_district_data)

    create_grades_hash(districts_by_name, key)
  end

  def group_subject_repo(contents, key)
    districts_by_year = sort_by_year(contents, key)
    all_district_data = districts_by_year.map do |district|
      name = district[:location]
      ethnicity = district[:race_ethnicity]
      data = truncate(district[:data].to_f)
      year = district[:timeframe].to_i
      {name: name, race: ethnicity, year => data}
    end
    districts_by_name = sort_by_name(all_district_data)

    create_subject_hash(districts_by_name, key)
  end

  def create_grades_hash(districts_by_name, key)
    district_testing_data = districts_by_name.map do |name, data|
      data_without_name = data.each do |grade_data|
        grade_data.delete(:name)
        grade_data
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
      {name: name, key => subjects_with_year}
    end
  end

  def create_subject_hash(districts_by_name, key)
    district_testing_data = districts_by_name.map do |name, data|
      by_race = data.group_by do |races|
        races[:race]
      end
      all_race_data = by_race.map do |race_name, race_data|
        data_by_race = race_data.each do |district_data|
          district_data.delete(:name)
          district_data.delete(:race)
        end.reduce({}, :merge)
        symbol = race_name.split("/").last.gsub(/\s+/,"_").downcase.to_sym
        {symbol => data_by_race}
      end.reduce({}, :merge)
      {name: name, key => all_race_data}
    end
  end

  def find_by_name(district_name)
    matching_object = statewide_test_repository.select do |test_object|
      test_object.name == district_name.upcase
    end
    matching_object.empty? ? nil : matching_object.last
  end

  def truncate(number)
    number.to_s[0..4].to_f
  end
end
