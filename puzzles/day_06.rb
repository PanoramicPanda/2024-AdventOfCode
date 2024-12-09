require_relative '../utilities/advent_helpers'

# Day 6: Guard Gallivant
#
# Tracks the movement of a guard through a map, so we know how many spots they visited before they left.
class GuardGallivant
  attr_reader :guard_positions, :unique_positions, :loop_locations

  # Initializes the guard tracker.
  def initialize
    AdventHelpers.print_christmas_header(6, 'Guard Gallivant')
    @map = []
    @original_map = []
    @guard_facing = '^'
    @guard_positions = []
    @unique_positions = []
    @loop_locations = []
    @current_guard_location = nil
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
  # If the location is not set, scans the map to find it.
  # Otherwise, returns the location from the instance variable.
  # Returns the guard's location as a pair of coordinates.
  #
  # @return [Array<Integer>, nil] The guard's location as a pair of coordinates.
  def get_guard_location
    unless @current_guard_location
      # Initialize @current_guard_location by scanning the map only once if not already set.
      @map.each_with_index do |row, row_index|
        row.each_with_index do |char, col_index|
          if %w[^ v < >].include?(char)
            @current_guard_location = [row_index, col_index]
            break
          end
        end
        break if @current_guard_location
      end
    end
    @current_guard_location
  end



  # Resets the map to its original state.
  # Also resets the guard's position to unknown.
  # And sets the assumed facing direction.
  #
  # @return [nil]
  def reset_map
    @map.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        @map[i][j] = @original_map[i][j]
      end
    end
    @guard_facing = '^'
    @current_guard_location = nil
  end

  # Checks if the guard has visited a position before ever.
  #
  # @param position [Array<Integer>] The position to check.
  #
  # @return [nil]
  def is_previous_unique_position?(position)
    @unique_positions.include?(position)
  end

  # Logs the guard's current position and facing.
  # Adds the position to the list of visited positions to log the route.
  # Adds the position to the list of unique positions to track the total visited only if it's a new tile.
  #
  # @param position [Array<Integer>] The position to log.
  #
  # @return [nil]
  def log_guard_position(position)
    facing = @guard_facing
    unless @guard_positions.any? { |pos, face| pos == position && face == facing }
      @guard_positions << [position, facing]
    end
    @unique_positions << position unless @unique_positions.include?(position)
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
    return 'Escape' if target.empty?
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
    return [] unless guard_location

    guard_facing = get_guard_facing
    return [] unless guard_facing

    [guard_location[0] + guard_facing[0], guard_location[1] + guard_facing[1]]
  end


  # Moves the guard from one position to another.
  # Changes the old position to a '.' and the new position to the guard's facing direction.
  # Updates the guard's current location in the instance variable.
  #
  # @param old_position [Array<Integer>] The guard's current location.
  # @param new_position [Array<Integer>] The guard's new location.
  # @param facing [String] The direction the guard is facing.
  #
  # @return [nil]
  def move_guard(old_position, new_position, facing)
    @map[old_position[0]][old_position[1]] = '.'
    @map[new_position[0]][new_position[1]] = facing
    @current_guard_location = new_position
  end

  # Tracks the guard's movement through the map.
  # Moving the guard to the next tile they are facing until they escape.
  # If the guard faces a wall, they turn right.
  # If the guard faces an empty space, they move forward.
  # If the guard escapes, the loop ends.
  # Logs the guard's position at each step.
  #
  # @return [nil]
  def track_guard
    Engine::Logger.action 'Tracking the guard...'
    location = get_guard_location # Initialize tracking
    target = get_guard_target(location)
    until target == 'Escape'
      case target
      when '#'
        log_guard_position(location)
        turn_right
        log_guard_position(location)
        target = get_guard_target(location)
      when '.'
        new_location = guard_target_coordinates(location)
        move_guard(location, new_location, @guard_facing)
        location = @current_guard_location
        log_guard_position(location)
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
    AdventHelpers.load_input_and_do(input) do |line|
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

  # Detects infinite loops based on placing a single new obstacle within the guard's path.
  # If the guard escapes, the obstacle doesn't cause a loop.
  # If the guard enters a loop, the obstacle is in a loop location and gets added to the list.
  #
  # @return [nil]
  def detect_infinite_loops
    Engine::Logger.action 'Looking for places to place obstacles to create infinite loops...'
    @guard_positions.each_with_index do |(position, facing), index|
      next_position = @guard_positions[index + 1]&.first
      next unless next_position && @original_map[next_position[0]][next_position[1]] == '.'

      reset_map
      place_obstacle(next_position)

      if simulate_guard_path
        next
      else
        @loop_locations << next_position unless @loop_locations.include?(next_position)
      end
    end
  end


  # Places an obstacle on the map at the given coordinates.
  # If the tile is the guard's starting position, it is not replaced.
  #
  # @param position [Array<Integer>] The coordinates where the obstacle is placed
  #
  # @return [nil]
  def place_obstacle(position)
    @map[position[0]][position[1]] = '#' unless @map[position[0]][position[1]] == '^'
  end

  # Simulates the guard's path on the current map
  # The guard moves until they escape or enter a loop.
  # Checks for loops by storing the guard's position and facing direction as they travel.
  # If the guard returns to a previous position and facing direction, it is now in a loop.
  #
  # @return [Boolean] True if the guard escapes, false if they enter a loop
  def simulate_guard_path
    visited_positions = {}
    location = get_guard_location
    target = get_guard_target(location)

    until target == 'Escape'
      case target
      when '#'
        turn_right
      when '.'
        new_location = guard_target_coordinates(location)
        move_guard(location, new_location, @guard_facing)
        location = @current_guard_location
      else
        return true
      end

      # Check for loop: same position and facing as before
      current_state = [location, @guard_facing]
      return false if visited_positions[current_state]

      visited_positions[current_state] = true
      target = get_guard_target(location)
    end
    true
  end

end

# Example usage
if __FILE__ == $PROGRAM_NAME
  solver = GuardGallivant.new
  solver.load_input('day_06.txt')
  AdventHelpers.part_header(1)
  solver.track_guard
  Engine::Logger.info "The guard visited [#{solver.unique_positions.length}] spots"
  AdventHelpers.part_header(2)
  solver.detect_infinite_loops
  Engine::Logger.info "The guard would have entered an infinite loop with a new obstacle at [#{solver.loop_locations.length}] spots"
end