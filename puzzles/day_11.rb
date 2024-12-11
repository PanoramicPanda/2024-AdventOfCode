require_relative '../utilities/advent_helpers'
# Day 11: Plutonian Pebbles
#
# This class takes a list of stones and blinks them according to a set of rules.
# The rules are as follows:
# - If the stone is 0, it becomes 1.
# - If the stone has an even number of digits, it is split in half and each half becomes a stone.
# - If the stone has an odd number of digits, it is multiplied by 2024.
class PlutonianPebbles
  attr_reader :stones

  # Initialize the class with an empty stones hash.
  #
  # @return [PlutonianPebbles] A new instance of PlutonianPebbles.
  def initialize
    AdventHelpers.print_christmas_header(10, 'Plutonian Pebbles')
    @stones = {}
  end

  # Load a list of stones into the stones hash.
  # Split the stones string into an array of integers and add them to the stones hash.
  # If the stone is already in the hash, increment the count.
  #
  # @param stones [String] The list of stones to load.
  #
  # @return [nil]
  def load_stones(stones)
    raw_stones = stones.strip.split(' ').map(&:to_i)
    raw_stones.each do |stone|
      @stones[stone] = 0 unless @stones[stone]
      @stones[stone] += 1
    end
  end

  # Increase the count of a stone in the new_stones hash.
  # If the stone is not in the new_stones hash, add it with a count of 0 before incrementing.
  #
  # @param stone [Integer] The stone to increase the count of.
  # @param amount [Integer] The amount to increase the count by. Defaults to 1.
  #
  # @return [nil]
  def increase_stone_count(stone, amount = 1)
    @new_stones[stone] = 0 unless @new_stones[stone]
    @new_stones[stone] += amount
  end

  # Decrease the count of a stone in the new_stones hash.
  # If the stone count reaches 0, remove the stone from the new_stones hash.
  #
  # @param stone [Integer] The stone to decrease the count of.
  # @param amount [Integer] The amount to decrease the count by. Defaults to 1.
  #
  # @return [nil]
  def decrease_stone_count(stone, amount = 1)
    @new_stones[stone] -= amount
    @new_stones.delete(stone) if @new_stones[stone] == 0
  end

  # Blink the stones a set number of times.
  # For each blink, create a new_stones hash to store the new stone counts.
  # Iterate over the stones hash and perform the blink on each stone.
  # Set the stones hash to the new_stones hash after each blink.
  #
  # @param times [Integer] The number of times to blink the stones. Defaults to 1.
  #
  # @return [nil]
  def blink(times = 1)
    time = Time.now
    Engine::Logger.action "Blinking [#{times}] times..."
    times.times do |i|
      @new_stones = @stones.dup
      @stones.each_pair do |stone, count|
        perform_blink_on_stone(stone, count)
      end
      @stones = @new_stones
    end

    time_diff = ((Time.now - time) * 1000).round(3)
    Engine::Logger.info "Blinking took [#{time_diff}] milliseconds."
  end

  # Perform the blink on a single stone.
  # If the stone is 0, it becomes 1.
  # If the stone has an even number of digits, it is split in half and each half becomes a stone.
  # If the stone has an odd number of digits, it is multiplied by 2024.
  #
  # @param stone [Integer] The stone to blink.
  # @param stone_count [Integer] The count of the stone to blink.
  #
  # @return [nil]
  def perform_blink_on_stone(stone, stone_count)
    stone_string = stone.to_s
    if stone == 0
      increase_stone_count(1, stone_count)
      decrease_stone_count(stone, stone_count)
    elsif stone_string.length.even?
      new_stones = stone_string.chars.each_slice(stone_string.size/2).map(&:join).map(&:to_i)
      new_stones.each do |new_stone|
        increase_stone_count(new_stone, stone_count)
      end
      decrease_stone_count(stone, stone_count)
    else
      new_stone = stone * 2024
      increase_stone_count(new_stone, stone_count)
      decrease_stone_count(stone, stone_count)
    end
  end

  # Count the total number of stones in the stones hash.
  # Iterate over the stones hash and increment the count by the amount of each stone.
  #
  # @return [Integer] The total number of stones in the stones hash.
  def count_stones
    count = 0
    @stones.each_pair do |stone, amount|
      count += amount
    end
    count
  end

  # Load the input from a file and process it line by line.
  # If the input is a filename, it is loaded from the inputs directory.
  #
  # @param input [String] The name of the file to load.
  def load_input(input)
    AdventHelpers.load_input_and_do(input) do |line|
      load_stones(line)
    end
  end
end

# Example usage:
if __FILE__ == $PROGRAM_NAME
  solver = PlutonianPebbles.new
  solver.load_input('day_11.txt')
  solver.blink(25)
  Engine::Logger.info "The final amount of stones after [25] total blinks is: #{solver.count_stones}"
  solver.blink(50)
  Engine::Logger.info "The final amount of stones after [75] total blinks is: #{solver.count_stones}"
end