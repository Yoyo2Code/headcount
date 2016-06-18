require_relative 'data_errors'
require 'pry'

class StatewideTest
  attr_accessor :name, :third_grade, :eighth_grade, :math, :reading, :writing

  def initialize(test_data)
    @name = test_data[:name].upcase
    @third_grade = test_data[:third_grade]
    @eighth_grade = test_data[:eighth_grade]
    @math = test_data[:math]
    @reading = test_data[:reading]
    @writing = test_data[:writing]
  end

  def proficient_by_grade(grade)
    if grade == 3
      third_grade
    elsif grade == 8
      eighth_grade
    else
      fail UnknownDataError
    end
  end

  def proficient_by_race_or_ethnicity(race)
    year_hash = {}
    if valid_race?(race)
      reading_scores = reading[race]
      writing_scores = writing[race]
      math_scores = math[race]

      math_scores.each_key do |key|
        data_by_subject = {:reading => reading_scores[key],
                           :writing => writing_scores[key],
                           :math => math_scores[key]}
        year_hash[key] = data_by_subject
      end
      year_hash
    else
      fail UnknownRaceError
    end
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    if valid_subject?(subject) && valid_grade?(grade) && valid_year?(year)
      get_data_by_grade_and_year_and_subject(subject, grade, year)
    else
      fail UnknownDataError
    end
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    if valid_race?(race) && valid_subject?(subject) && valid_year?(year)
      get_data_by_subject_and_ethnicity_and_year(subject, race, year)
    else
      fail UnknownDataError
    end
  end

  def get_data_by_grade_and_year_and_subject(subject, grade, year)
    if grade == 3
      if third_grade[year][subject] == 0.0
        "N/A"
      else
        third_grade[year][subject]
      end
    elsif grade == 8
      if eighth_grade[year][subject] == 0.0
        "N/A"
      else
        eighth_grade[year][subject]
      end
    end
  end

  def get_data_by_subject_and_ethnicity_and_year(subject, ethnicity, year)
    if subject == :math
      math[ethnicity][year]
    elsif subject == :reading
      reading[ethnicity][year]
    elsif subject == :writing
      writing[ethnicity][year]
    end
  end

  def valid_race?(race)
    valid_races = [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
    valid_races.include?(race)
  end

  def valid_subject?(subject)
    valid_subjects = [:math, :reading, :writing]
    valid_subjects.include?(subject)
  end

  def valid_grade?(grade)
    valid_grades = [3, 8]
    valid_grades.include?(grade)
  end

  def valid_year?(year)
    valid_years = [2008, 2009, 2010, 2011, 2012, 2013, 2014]
    valid_years.include?(year)
  end
end
