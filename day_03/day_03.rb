require_relative '../utilities/advent_helpers'
# Day 3 - Mull It Over
#
# This class provides methods to extract and execute mul commands from a string.
class MullItOver
  attr_reader :muls, :mul_total

  # Initializes a new instance of MullItOver.
  #
  # @return [nil]
  def initialize
    @muls = []
    @mul_total = 0
    @raw_memory = []
  end

  # Adds a mul command to the muls array
  #
  # @mul [String] The mul command to add. Expected to be in the format "mul(1,2)"
  # @return [nil]
  def add_mul(mul)
    @muls << mul
  end

  # Extracts all mul commands from a string and adds them to the muls array
  # Uses a regex to find all instances of "mul(1,2)"
  #
  # @param memory [String] The string to extract mul commands from.
  # @return [nil]
  def extract_muls(memory)
    memory.scan(/mul\(\d{1,3},\d{1,3}\)/) do |mul|
      add_mul(mul)
    end
  end

  # Extracts mul commands from a string, but only adds them to the muls array if they are enabled.
  # Uses a regex to find all instances of "mul(1,2)" and "do()" or "don't()"
  # If "do()" is found, all proceeding found mul commands are enabled.
  # If "don't()" is found, all proceeding found mul commands are disabled.
  #
  # @param memory [String] The string to extract mul commands from.
  # @return [nil]
  def extract_only_enabled_muls(memory)
    @enabled = true if @enabled.nil?
    memory.scan(/(mul\(\d{1,3},\d{1,3}\))|(do\(\))|(don't\(\))/) do |mul, do_mul, dont_mul|
      if do_mul
        puts 'enabled'
        @enabled = true
      elsif dont_mul
        puts '---disabled---'
        @enabled = false
      end
      add_mul(mul) if @enabled && mul
    end
  end

  # Executes a mul command and returns the result.
  # Uses a regex to extract the two numbers from the mul command.
  # Multiplies the two numbers together and returns the result.
  #
  # @param mul [String] The mul command to execute. Expected to be in the format "mul(1,2)"
  def execute_mul(mul)
    numbers = mul.scan(/\d{1,3}/)
    numbers[0].to_i * numbers[1].to_i
  end

  # Executes all mul commands in the muls array and adds the results together.
  #
  # @return [nil]
  def execute_all_muls
    @mul_total = 0
    @muls.each do |mul|
      @mul_total += execute_mul(mul) if mul.include?('mul')
    end
  end

  # Processes each line from the memory array and extracts all mul commands from each line.
  #
  # @return [nil]
  def extract_all_muls_from_memory
    @muls = []
    @raw_memory.each do |memory|
      extract_muls(memory)
    end
  end

  # Processes each line from the memory array and extracts only enabled mul commands from each line.
  #
  # @return [nil]
  def extract_only_enabled_muls_from_memory
    @muls = []
    @raw_memory.each do |memory|
      extract_only_enabled_muls(memory)
    end
  end

  # Loads the input file, and adds each line to the raw_memory array.
  #
  # @param input_file [String] The name of the input file. Expected to be in the inputs directory.
  # @return [nil]
  def load_input(input_file)
    AdventHelpers.load_file_and_do(input_file) do |line|
      @raw_memory << line
    end
  end
end

# Example usage:
if __FILE__ == $0
  memory = MullItOver.new
  memory.load_input("day_03.txt")
  memory.extract_all_muls_from_memory
  memory.execute_all_muls
  puts "Part 1 Total: #{memory.mul_total}"
  memory.extract_only_enabled_muls_from_memory
  memory.execute_all_muls
  puts "Part 2 Total: #{memory.mul_total}"
end