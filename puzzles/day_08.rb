require_relative '../utilities/advent_helpers'

# Day 8: Resonant Collinearity
# The ResonantCollinearity class is used to find the number of antinodes on a map.
# Antinodes are placed on the map between pairs of antennas.
#
# The class can also find resonant antinodes, which are antinodes that continue the pattern of antinode placement until the antinode is out of bounds.
class ResonantCollinearity

  attr_reader :map, :antinode_map

  # Initializes the ResonantCollinearity class.
  #
  # @return [ResonantCollinearity] The ResonantCollinearity class.
  def initialize
    @map = []
    @antinode_map = []
  end

  # Adds a row to the map.
  #
  # @param row [String] The row to add.
  #
  # @return [nil]
  def add_row(row)
    @map << row.strip.split('')
  end

  # Loads the input and creates a blank antinode map.
  #
  # @param input [String] The input to load.
  #
  # @return [nil]
  def load_input(input)
    AdventHelpers.load_input_and_do(input) do |line|
      add_row(line)
    end
    make_blank_antinode_map
  end

  # Creates a blank antinode map that is the same size as the map.
  # The antinode map is used to store the positions of the antinodes.
  #
  # @return [nil]
  def make_blank_antinode_map
    @antinode_map = Array.new(@map.length) { Array.new(@map[0].length) }
  end

  # Finds the absolute distance between two antennas.
  # For example, if the first antenna is at [1,1] and the second antenna is at [2,2], the distance is [1,1].
  # If the first antenna is at [1,1] and the second antenna is at [1,2], the distance is [0,1].
  #
  # @param first_antenna [Array<Integer>] The coordinates of the first antenna.
  # @param second_antenna [Array<Integer>] The coordinates of the second antenna.
  #
  # @return [Array<Integer>] The absolute distance between the two antennas.
  def find_distance(first_antenna, second_antenna)
    [(first_antenna[0] - second_antenna[0]).abs, (first_antenna[1] - second_antenna[1]).abs]
  end

  # Determines where an antinode is relative to an antenna given two antenna and the absolute distance between them.
  # For example, if the antenna is at [2,5], and the other antenna is at [4,4] (2 units down and 1 unit left).
  # The distance between the two antennas is [2,1]. Since the other antenna is down and left, the antinode is up and right.
  # So the change from our antenna to the antinode is [-2,1].
  #
  # @param current_antenna [Array<Integer>] The coordinates of the current antenna.
  # @param other_antenna [Array<Integer>] The coordinates of the other antenna.
  # @param distance [Array<Integer>] The absolute Y, X distance between the two antennas.
  #
  # @return [Array<Integer>] The multiplication to use on the distance coordinates.
  def determine_antinode_relative_position(current_antenna, other_antenna, distance)
    [(current_antenna[0] <=> other_antenna[0]) * distance[0], (current_antenna[1] <=> other_antenna[1])*distance[1]]
  end

  # Determines the position of the antinode given the current antenna and the relative position.
  # For example, if the current antenna is at [2,5] and the relative position is [-2,1], the antinode is at [0,6].
  #
  # @param current_antenna [Array<Integer>] The coordinates of the current antenna.
  # @param relative_position [Array<Integer>] The relative position of the antinode.
  #
  # @return [Array<Integer>] The coordinates of the antinode.
  def determine_antinode_position(current_antenna, relative_position)
    [current_antenna[0] + relative_position[0], current_antenna[1] + relative_position[1]]
  end

  # Places an antinode on the map at the given position.
  # If the antinode is out of bounds, it is not placed.
  #
  # @param antinode_position [Array<Integer>] The coordinates of the antinode.
  #
  # @return [nil]
  def place_antinode(antinode_position)
    return if antinode_position[0] < 0 || antinode_position[1] < 0 || antinode_position[0] >= @map.length || antinode_position[1] >= @map[0].length
    @antinode_map[antinode_position[0]][antinode_position[1]] = '#'
  end

  # Determines the positions of both antinodes given the positions of the two antennas and places them on the map.
  # If the antinode is out of bounds, it is not placed.
  #
  # @param first_antenna [Array<Integer>] The coordinates of the first antenna.
  # @param second_antenna [Array<Integer>] The coordinates of the second antenna.
  #
  # @return [nil]
  def place_antinodes(first_antenna, second_antenna)
    distance = find_distance(first_antenna, second_antenna)
    relative_position = determine_antinode_relative_position(first_antenna, second_antenna, distance)
    antinode_position = determine_antinode_position(first_antenna, relative_position)
    place_antinode(antinode_position)
    relative_position = determine_antinode_relative_position(second_antenna, first_antenna, distance)
    antinode_position = determine_antinode_position(second_antenna, relative_position)
    place_antinode(antinode_position)
  end

  # Find all pairs of antennas on the map.
  # For each antenna, a pair is formed with every antenna of the same character that is not itself on the map.
  # Each pair, once found, is sorted and then stored. If a sorted pair is already stored, it is not stored again.
  #
  # @return [Array<Array<Array<Integer>>] An array of pairs of antennas.
  def find_antenna_pairs
    antenna_pairs = []
    @map.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        next if cell == '.'
        @map.each_with_index do |row2, y2|
          row2.each_with_index do |cell2, x2|
            next if cell2 == '.' || (y2 == y && x2 == x) || cell2 != cell
            pair = [[y, x], [y2, x2]].sort
            antenna_pairs << pair unless antenna_pairs.include?(pair)
          end
        end
      end
    end
    antenna_pairs
  end

  # Places all antinodes on the map for each pair of antennas.
  #
  # @return [nil]
  def place_all_antinodes
    find_antenna_pairs.each do |pair|
      place_antinodes(pair[0], pair[1])
    end
  end

  # Counts the number of antinodes on the map.
  #
  # @return [Integer] The number of antinodes on the map.
  def count_antinodes
    @antinode_map.flatten.count('#')
  end

  # Resonant antinodes continues the pattern of antinode placement until the antinode is out of bounds.
  # We do this by finding the antinode of a pair, then placing antinodes along the entire repeated distance line across the map
  # until the antinode is out of bounds. We do this in both directions of the antinode.
  # This includes the positions of the antennas themselves.
  #
  # @return [nil]
  def place_resonant_antinodes
    find_antenna_pairs.each do |pair|
      distance = find_distance(pair[0], pair[1])
      relative_position = determine_antinode_relative_position(pair[0], pair[1], distance)
      antinode_position = determine_antinode_position(pair[0], relative_position)
      while antinode_position[0] >= 0 && antinode_position[1] >= 0 && antinode_position[0] < @map.length && antinode_position[1] < @map[0].length
        place_antinode(antinode_position)
        antinode_position = determine_antinode_position(antinode_position, relative_position)
      end
      relative_position = determine_antinode_relative_position(pair[1], pair[0], distance)
      antinode_position = determine_antinode_position(pair[1], relative_position)
      while antinode_position[0] >= 0 && antinode_position[1] >= 0 && antinode_position[0] < @map.length && antinode_position[1] < @map[0].length
        place_antinode(antinode_position)
        antinode_position = determine_antinode_position(antinode_position, relative_position)
      end
      @antinode_map[pair[0][0]][pair[0][1]] = '#'
      @antinode_map[pair[1][0]][pair[1][1]] = '#'
    end
  end


end

if __FILE__ == $0
  solver = ResonantCollinearity.new
  solver.load_input('day_08.txt')
  solver.place_all_antinodes
  puts "Found #{solver.count_antinodes} antinodes"
  solver.place_resonant_antinodes
  puts "Found #{solver.count_antinodes} resonant antinodes"
end