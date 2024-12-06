require_relative '../utilities/advent_helpers'

# Day 6: Guard Gallivant
#
# Tracks the movement of a guard through a map, so we know how many spots they visited before they left.
class GuardGallivant
  attr_reader :guard_positions

  # Initializes the guard tracker.
  def initialize
    @map = []
    @original_map = []
    @guard_facing = '^'
    @guard_positions = []
  end

  # Adds a row to the map, splitting it into individual characters.
  #
  # @param row [String] The row to add to the map.
  #
  # @return [nil]
  def add_row(row)
    @map << row.strip.split('')
  end

  # Hash of facing directions to vectors.
  # Used to determine which tile the guard is looking at.
  #
  # @return [Hash<String, Array<Integer>>] The hash of facing directions to vectors.
  def facing_vectors
    {
      '^' => [-1, 0],
      'v' => [1, 0],
      '<' => [0, -1],
      '>' => [0, 1]
    }
  end

  # Gets the guard's current facing direction.
  # Uses a hash to map the direction to a vector.
  #
  # @return [Array<Integer>] The vector representing the guard's facing direction.
  def get_guard_facing
    facing_vectors[@guard_facing]
  end

  # Gets the guard's current location.
  # Iterates through the map to find the guard.
  # Also logs the guard's position if it hasn't been seen before.
  # Returns the guard's location as a pair of coordinates.
  #
  # @return [Array<Integer>] The guard's location as a pair of coordinates.
  def get_guard_location
    guard_location = []
    @map.each_with_index do |row, row_index|
      row.each_with_index do |char, col_index|
        if char == "^" || char == "v" || char == "<" || char == ">"
          guard_location = [row_index, col_index]
          log_guard_position(guard_location)
          @guard_facing = char
        end
      end
    end
    guard_location
  end

  # Resets the map to its original state.
  # Also resets the guard's position list and facing direction.
  #
  # @return [nil]
  def reset_map
    @map = @original_map.map(&:dup)
    @guard_positions = []
    @guard_facing = '^'
  end

  # Checks if the guard has visited a position before.
  #
  # @param position [Array<Integer>] The position to check.
  #
  # @return [nil]
  def is_previous_position?(position)
    @guard_positions.include?(position)
  end

  # Logs the guard's current position.
  #
  # @param position [Array<Integer>] The position to log.
  #
  # @return [nil]
  def log_guard_position(position)
    @guard_positions << position unless @guard_positions.include?(position)
  end

  # Uses @guard_facing to determine the current direction.
  # Turns the guard to the right based on a case statement.
  #
  # @return [nil]
  def turn_right
    case @guard_facing
    when '^'
      @guard_facing = '>'
    when 'v'
      @guard_facing = '<'
    when '<'
      @guard_facing = '^'
    when '>'
      @guard_facing = 'v'
    end
  end

  # Looks at the tile the guard is facing.
  # If the guard is facing off the map, returns 'Escape'.
  # Otherwise, returns the tile the guard is facing.
  #
  # @param guard_location [Array<Integer>] The guard's current location.
  #
  # @return [Array<Integer>, String] The tile the guard is facing.
  def get_guard_target(guard_location)
    target = guard_target_coordinates(guard_location)
    return 'Escape' if target[0] < 0 || target[0] >= @map.length || target[1] < 0 || target[1] >= @map[0].length
    @map[target[0]][target[1]]
  end

  # Calculates the coordinates of the tile the guard is facing.
  # Adds the guard's facing direction to their current location.
  #
  # @param guard_location [Array<Integer>] The guard's current location.
  #
  # @return [Array<Integer>] The coordinates of the tile the guard is facing.
  def guard_target_coordinates(guard_location)
    guard_facing = get_guard_facing
    [guard_location[0] + guard_facing[0], guard_location[1] + guard_facing[1]]
  end

  # Moves the guard from one position to another.
  # Changes the old position to a '.' and the new position to the guard's facing direction.
  #
  # @param old_position [Array<Integer>] The guard's current location.
  # @param new_position [Array<Integer>] The guard's new location.
  # @param facing [String] The direction the guard is facing.
  #
  # @return [Array<Array<String>>] The updated map.
  def move_guard(old_position, new_position, facing)
    @map[old_position[0]][old_position[1]] = '.'
    @map[new_position[0]][new_position[1]] = facing
  end

  # Tracks the guard's movement through the map.
  # Moving the guard to the next tile they are facing until they escape.
  # If the guard faces a wall, they turn right.
  # If the guard faces an empty space, they move forward.
  # If the guard escapes, the loop ends.
  # Prints 'Escaped!' when the guard escapes.
  # Logs the guard's position at each step.
  #
  # @return [nil]
  def track_guard
    location = get_guard_location
    target = get_guard_target(location)
    until target == 'Escape'
      case target
      when '#'
        turn_right
        target = get_guard_target(location)
      when '.'
        new_location = guard_target_coordinates(location)
        move_guard(location, new_location, @guard_facing)
        location = get_guard_location
        target = get_guard_target(location)
      else
        puts 'Escaped!'
      end
    end
  end

  # Loads the input file and adds each row to the map.
  # Saves the original map for later use.
  #
  # @param input [String] The name of the file to load.
  #
  # @return [nil]
  def load_input(input)
    AdventHelpers.load_file_and_do(input) do |line|
      add_row(line)
    end
    save_original_map
  end

  # Saves the original map for later use.
  #
  # @return [nil]
  def save_original_map
    @original_map = @map.map(&:dup)
  end

end

# Example usage
if __FILE__ == $PROGRAM_NAME
  solver = GuardGallivant.new
  solver.load_input('day_06.txt')
  solver.track_guard
  puts "The guard visited #{solver.guard_positions.length} spots."
end