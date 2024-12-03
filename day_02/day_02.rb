require_relative '../utilities/advent_helpers'
# Day 2 - Red Nosed Reports
#
# This class provides methods to inspect reports and determine if they are safe or unsafe.
class RedNosedReports

  # Initializes the RedNosedReports class.
  #
  # @return [nil]
  def initialize
    @reports = []
    @safe_reports = []
    @unsafe_reports = []
  end

  # Adds a report to the reports array.
  #
  # @param report [Array] The report to add.
  # @return [nil]
  def add_report(report)
    @reports << report
  end

  # Clears the safe and unsafe reports arrays, then inspects each report to determine if it is safe or unsafe.
  # Loads the safe reports into the @safe_reports array and the unsafe reports into the @unsafe_reports array.
  #
  # @return [nil]
  def load_initial_reports
    @safe_reports = []
    @unsafe_reports = []
    @reports.each do |report|
      safe = inspect_report(report)
      safe ? @safe_reports << report : @unsafe_reports << report
    end
  end

  # Inspects a report to determine if it is safe or unsafe.
  # A report is considered safe if:
  # - The numbers in the report are in ascending or descending order.
  # - The difference between any two numbers in the report is less than or equal to 3, and greater than or equal to 1.
  #
  # @param report [Array] The report to inspect.
  # @return [Boolean] True if the report is safe, false if it is unsafe.
  def inspect_report(report)
    directions = []
    level_differences = []

    report.each_with_index do |number, index|
      if index > 0
        if number < report[index - 1]
          directions << -1
        elsif number > report[index - 1]
          directions << 1
        elsif number == report[index - 1]
          directions << 0
        end

        level_differences << (number - report[index - 1]).abs
      end
    end
    directions.uniq!

    return false if directions.length != 1
    return false if level_differences.max > 3
    return false if level_differences.min < 1
    true
  end

  # Dampens the unsafe reports by removing one number from each report and checking if the report is made safe.
  # If the report is now safe, it is added to the safe reports array.
  #
  # @return [nil]
  def dampen_unsafe_reports
    @unsafe_reports.each do |report|
      report.each_with_index do |number, index|
        new_report = report.dup
        new_report.delete_at(index)
        safe = inspect_report(new_report)
        if safe
          @safe_reports << new_report
          break
        end
      end
    end
  end

  # Returns the number of safe reports.
  #
  # @return [Integer] The number of safe reports.
  def safe_report_count
    @safe_reports.length
  end

  # Reports the number of safe reports as a string.
  #
  # @return [nil]
  def report_safe_report_count
    puts "Safe reports: #{safe_report_count}"
  end

  # Loads the input file, and adds each report to the reports array.
  #
  # @param input_file [String] The name of the input file. Expected to be in the inputs directory.
  # @return [nil]
  def load_input(input_file)
    @reports = []
    AdventHelpers.load_file_and_do(input_file) do |line|
      report = line.split.map(&:to_i)
      add_report(report)
    end
  end

end

# Example Usage
if __FILE__ == $0
  red_nosed_reports = RedNosedReports.new
  red_nosed_reports.load_input("day_02.txt")
  red_nosed_reports.load_initial_reports
  red_nosed_reports.report_safe_report_count
  red_nosed_reports.dampen_unsafe_reports
  red_nosed_reports.report_safe_report_count
end