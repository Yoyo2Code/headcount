require 'pp'
require 'csv'

module DataLoader

  def load_household_income(key, contents)
    formatted = contents.map do |row|
      name   = name(row)
      year   = list_years(time(row))
      amount = integer_data(row)
      {name: name, year => amount}
    end
      districts = group_by_location(formatted)
      create_household_income(districts, key)
  end

  def load_childhood_poverty(key, contents)
    formatted = contents.map do |row|
      name   = name(row)
      year   = time(row).to_i
      data = float_data(row)
      {name: name, year => data}
    end
    districts = group_by_location(formatted)
    districts.map do |name, data|
      formatted_data = delete_name(data)
      formatted_data = formatted_data.reduce({},:merge)
      is_title_i?(key, formatted_data)
      {name: name, key => formatted_data}
    end
  end

  def load_free_or_reduced_lunch(key, contents)
    formatted_data = contents.map do |row|
      name   = name(row)
      year   = time(row).to_i
      data   = float_data(row).to_f
      displayed_format = row[:dataformat].to_sym
        if percent_lunch_format?(displayed_format)
          lunch_percent_input(name, year, displayed_format, data)
        else
          lunch_number_input(name, year, displayed_format, data)
        end
    end
    districts = group_by_location(formatted_data)
      districts_with_data = format_by_districts(key, districts)
        hi = districts_with_data.map do |district|
           raw_data = district[:free_or_reduced_price_lunch]
            by_year = group_by_year(raw_data)
        yearly_data = calculate_yearly_data(by_year)
      district_name = district.first.last
      {name: district_name, key => yearly_data}
    end
  end

  def load_title_i(key, contents)
    load_childhood_poverty(key, contents)
  end

  def percent_lunch_format?(data_format)
    if data_format == :Percent
      true
    end
  end

  def lunch_percent_input(name, year, data_format, data)
    {name: name, year => {data_format => data}}
  end

  def lunch_number_input(name, year, data_format, data)
    {name: name, year => {data_format => data}}
  end


  def group_by_location(content)
    content.group_by do |content|
      content[:name]
    end
  end

  def list_years(years)
    result = years.split("-").map {|year| year.to_i}
  end

  def calculate_total(numbers)
    numbers.inject(0) do |result, number|
      result + number
    end
  end

  def truncate(number)
    number.to_s[0..4].to_f
  end

  def delete_name(data)
    data.each do |information|
      information.delete(:name)
      information
    end
  end

  def calculate_yearly_data(by_year)
    yearly_data = by_year.map do |year, data|
      total_number = []
      total_percent = []
      data.each do |single_data|
        if has_number_as_symbol?(year, single_data)
          total_number << single_data[year].values.first
        elsif has_percent_as_symbol?(year, single_data)
          total_percent << single_data[year].values.first
        end
      end
      number = truncate(calculate_total(total_number))
      percent = truncate(calculate_total(total_percent))
      {year => {percentage: percent, total: number}}
    end.reduce({}, :merge)
  end

  def has_number_as_symbol?(year, data)
    data[year].keys.first == :Number
  end

  def has_percent_as_symbol?(year, data)
    data[year].keys.first == :Percent
  end

  def group_by_year(mixed_data)
    mixed_data.group_by do |data|
      data.keys.first
    end
  end

  def format_by_districts(key, districts)
    districts.map do |name, data|
      formatted_data = delete_name(data)
      {name: name, key => formatted_data}
    end
  end

  def delete_name_and_merge(formatted_data)
    formatted_data.map do |year, float|
      formatted_number = truncate(float)
      {year => formatted_number}
    end.reduce({}, :merge)
  end

  def delete_name_in_data(data)
    data.each do |income_data|
      income_data.delete(:name)
    end.reduce({}, :merge)
  end

  def name(input)
    input[:location]
  end

  def time(input)
    input[:timeframe]
  end

  def float_data(input)
    input[:data].to_f
  end

  def integer_data(input)
    input[:data].to_i
  end

  def is_title_i?(key, formatted_data)
    if key == :title_i
      delete_name_and_merge(formatted_data)
    end
  end

  def create_household_income(districts, key)
    districts.map do |name, data|
      formatted_data = delete_name_in_data(data)
          {name: name, key => formatted_data}
    end
  end
end
