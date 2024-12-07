require_relative '../utilities/advent_helpers'

# Day 7: Bridge Repair
# Tracks the numbers in a calibration and determines if they can be evaluated to match the calibration.
class BridgeRepair
  attr_reader :calibrations

  # Initializes the bridge repair tracker.
  #
  # @return [nil]
  def initialize
    @operators = ['+','*']
    @calibrations = {}
  end

  # Loads the numbers from a line into the calibrations hash.
  # The key is the calibration, and the value is an array of numbers.
  # The numbers are split by spaces.
  # The calibration is split by a colon.
  # For example, given the line '190: 10 19', the calibration is 190 and the numbers are 10 and 19.
  #
  # @param line [String] The line to load.
  #
  # @return [nil]
  def load_numbers(line)
    line_split = line.split(':')
    @calibrations[line_split[0].to_i] = line_split[1].strip.split(' ').map(&:to_i)
  end

  # Given a calibration, determine if it can be evaluated.
  # A calibration can be evaluated if, from left to right,
  # numbers can utilize any combination of operators to equal the calibration.
  # We always evaluate from left to right.
  #
  # For example, given the calibration 190: 10 19
  # We first evaluate 10 + 19 = 29, which is not equal to 190.
  # We then evaluate 10 * 19 = 190, which is equal to 190.
  # Therefore, it's true.
  #
  # Given the calibration 3267: 81 40 27
  # We first evaluate 81 + 40 + 27 = 148, which is not equal to 3267.
  # We then evaluate 81 * 40 * 27 = 87120, which is not equal to 3267.
  # We then evaluate 81 * 40 + 27 = 3267, which is equal to 3267.
  # Therefore, it's true.
  #
  # Given the calibration 161011: 16 10 13
  # We first evaluate 16 + 10 + 13 = 39, which is not equal to 161011.
  # We then evaluate 16 * 10 * 13 = 2080, which is not equal to 161011.
  # We then evaluate 16 * 10 + 13 = 173, which is not equal to 161011.
  # We then evaluate 16 + 10 * 13 = 338, which is not equal to 161011.
  # Since we've exhausted all possible combinations, it's false.
  #
  # @param calibration [Integer] The calibration to evaluate.
  # @param concat [Boolean] True if we should try to concatenate the numbers as an operation, false otherwise.
  #
  # @return [Boolean] True if the calibration can be evaluated, false otherwise.
  def can_eval?(calibration, concat: false)
    operators = concat ? @operators + ['||'] : @operators
    operator_combinations = operators.repeated_permutation(@calibrations[calibration].length - 1).to_a
    operator_combinations.each_with_index do |operator, index|
      result = @calibrations[calibration][0]
      @calibrations[calibration].each_with_index do |num, num_index|
        next if num_index == 0
        if operator[num_index - 1] == '||'
          result = (result.to_s + num.to_s).to_i
        else
          result = result.send(operator[num_index - 1], num)
        end
        if result > calibration
          break
        end
      end
      return true if result == calibration
    end
    false
  end

  # Sums the correct evaluations.
  # For each loaded calibration, if it can be evaluated, add it to the sum.
  #
  # @param concat [Boolean] True if we should try to concatenate the numbers as an operation, false otherwise.
  #
  # @return [Integer] The sum of the correct evaluations.
  def sum_correct_evaluations(concat: false)
    @calibrations.select { |calibration, _| can_eval?(calibration, concat: concat) }.keys.sum
  end

  # Loads the input file and processes each line.
  #
  # @param input [String] The name of the file to load.
  #
  # @return [nil]
  def load_input(input)
    AdventHelpers.load_file_and_do(input) do |line|
      load_numbers(line)
    end
  end
end

# Example usage
if __FILE__ == $PROGRAM_NAME
  solver = BridgeRepair.new
  solver.load_input('day_07.txt')
  puts "Sum of correct evaluations: #{solver.sum_correct_evaluations}"
  puts "Sum of correct evaluations with concatenation: #{solver.sum_correct_evaluations(concat: true)}"
end