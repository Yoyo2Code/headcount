require_relative 'economic_profile'
require_relative 'data_loader'
require 'pp'
require 'pry'

class EconomicProfileRepository
  attr_reader :data
  attr_accessor :economic_repo

  include DataLoader

  def initialize
    @economic_repo = []
  end

  def load_data(file_tree)
    data_file = file_tree[:economic_profile]
      data_file.map do |key,file|
      contents = CSV.read file, headers: true, header_converters: :symbol
      districts_sorted_by_time = contents.sort_by do |contents|
        contents[:timeframe]
      end
      @data = determine_path(key, districts_sorted_by_time)
      create_single_repo(data)
    end
    group_by_district!
    delete_name_in_repo!
    create_economic_profles!
  end

  def determine_path(key, contents)
    case key
    when :median_household_income
      @household_repo = load_household_income(key, contents)
    when :children_in_poverty
      @childhood_poverty_repo = load_childhood_poverty(key, contents)
    when :free_or_reduced_price_lunch
      @lunch_repo = load_free_or_reduced_lunch(key, contents)
    when :title_i
      @title_i_repo = load_title_i(key, contents)
    end
  end

  def group_by_district!
    @economic_repo = economic_repo.group_by do |fragment|
      fragment[:name]
    end
  end

  def create_single_repo(*data)
    data.each do |repos|
      repos.each do |single_fragment|
      @economic_repo << single_fragment
      end
    end
  end

  def delete_name_in_repo!
    @economic_repo = economic_repo.map do |name, data|
      data_without_name = data.each do |data_with_name|
        data_with_name.delete(:name)
        data_with_name
      end.reduce({}, :merge)
      {name: name}.merge(data_without_name)
    end
  end

  def create_economic_profles!
    @economic_repo = economic_repo.map do |data_by_district|
      EconomicProfile.new(data_by_district)
    end
  end
end
