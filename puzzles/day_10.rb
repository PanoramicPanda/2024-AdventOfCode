require_relative '../utilities/advent_helpers'

# Day 10: Hoof It
#
# This class takes a trail map and finds the trails from 0 to 9, then scores and rates them.
class HoofIt


  # Initialize the class with an empty trail map, connected map, and trailheads.
  #
  # @return [HoofIt] A new instance of HoofIt.
  def initialize
    AdventHelpers.print_christmas_header(10, 'Hoof It')
    @trail_map = []
    @connected_map = {}
    @trailheads = []
  end

  # Load a row of the trail map.
  # Split the row into individual characters, convert them to integers, and add them to the trail map as an array.
  #
  # @param row [String] The row of the trail map to load.
  #
  # @return [nil]
  def load_map_row(row)
    @trail_map << row.split('').map(&:to_i)
  end

  # Make a connected map from the trail map.
  # Iterate over the trail map and create a connected map with the value of the cell and the connected cells.
  #
  # @return [nil]
  def make_map
    @trail_map.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        @connected_map[[y, x]] = {
          value: cell,
          connected: look_around([y, x])
        }
      end
    end
  end

  # Find the trailheads in the trail map.
  # Iterate over the trail map and add the coordinates of the trailheads to the trailheads array.
  #
  # @return [nil]
  def find_trailheads
    Engine::Logger.action 'Finding trailheads...'
    @trail_map.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        @trailheads << [y, x] if cell == 0
      end
    end
  end

  # List the trailheads.
  #
  # @return [Array<Array<Integer>>] The trailheads.
  def list_trailheads
    @trailheads
  end

  # Find all the trails from a given trailhead to a target value.
  # Recursively find all the trails from a given trailhead to a target value.
  #
  # @param start_coordinates [Array<Integer>] The coordinates of the trailhead.
  # @param target_value [Integer] The target value to find.
  # @param current_path [Array<Array<Integer>>] The current path.
  # @param paths [Array<Array<Array<Integer>>] The paths found.
  #
  # @return [Array<Array<Array<Integer>>] The paths found.
  def find_trails(start_coordinates, target_value, current_path = [], paths = [])
    current_node = @connected_map[start_coordinates]
    return paths if current_node.nil?

    current_path = current_path + [start_coordinates]

    if current_node[:value] == target_value
      paths << current_path
    end

    current_node[:connected].each do |direction, node|
      next unless node
      next unless node[:value] == current_node[:value] + 1

      find_trails(node[:coordinates], target_value, current_path, paths)
    end

    paths
  end

  # Score a trailhead by finding all the trails from the trailhead to the goal and counting the unique end points.
  #
  # @param trailhead [Array<Integer>] The coordinates of the trailhead.
  # @param goal [Integer] The goal value to find. Default is 9.
  #
  # @return [Integer] The score of the trailhead.
  def score_trailhead(trailhead, goal: 9)
    Engine::Logger.debug "Scoring trailhead at [#{trailhead}]..."
    score = 0
    scored_paths = []
    paths = find_trails(trailhead, goal)
    paths.each do |path|
      unless scored_paths.include?(path.last)
        score += 1
        scored_paths << path.last
      end
    end
    score
  end

  # Rate a trailhead by finding all the trails from the trailhead to the goal and counting them.
  #
  # @param trailhead [Array<Integer>] The coordinates of the trailhead.
  # @param goal [Integer] The goal value to find. Default is 9.
  #
  # @return [Integer] The rating of the trailhead.
  def rate_trailhead(trailhead, goal: 9)
    Engine::Logger.debug "Rating trailhead at [#{trailhead}]..."
    find_trails(trailhead, goal).length
  end

  # Score the map by scoring all the trailheads.
  #
  # @return [Integer] The score of the map.
  def score_map
    Engine::Logger.action 'Scoring map...'
    find_trailheads if @trailheads.empty?
    make_map if @connected_map.empty?
    scores = []
    @trailheads.each do |trailhead|
      scores << score_trailhead(trailhead)
    end
    scores.sum
  end

  # Rate the map by rating all the trailheads.
  #
  # @return [Integer] The rating of the map.
  def rate_map
    Engine::Logger.action 'Rating map...'
    find_trailheads if @trailheads.empty?
    make_map if @connected_map.empty?
    ratings = []
    @trailheads.each do |trailhead|
      ratings << rate_trailhead(trailhead)
    end
    ratings.sum
  end

  # Look around from a given set of coordinates.
  #
  # @param coordinates [Array<Integer>] The coordinates to look around from.
  #
  # @return [Hash<Symbol, Hash>] The values and coordinates of the cells around the given coordinates.
  def look_around(coordinates)
    {
      up: look_up_from(coordinates),
      down: look_down_from(coordinates),
      left: look_left_from(coordinates),
      right: look_right_from(coordinates)
    }
  end

  # Look up from a given set of coordinates.
  # If the new coordinates are out of bounds, return nil.
  # If the new coordinates are in bounds, return the value and coordinates of the cell.
  #
  # @param coordinates [Array<Integer>] The coordinates to look up from.
  #
  # @return [Hash<Symbol, Object>] The value and coordinates of the cell.
  def look_up_from(coordinates)
    new_coordinates = [coordinates[0] - 1, coordinates[1]]
    return nil if new_coordinates[0] < 0
    {value: @trail_map[new_coordinates[0]][new_coordinates[1]], coordinates: new_coordinates}
  end

  # Look down from a given set of coordinates.
  # If the new coordinates are out of bounds, return nil.
  # If the new coordinates are in bounds, return the value and coordinates of the cell.
  #
  # @param coordinates [Array<Integer>] The coordinates to look down from.
  #
  # @return [Hash<Symbol, Object>] The value and coordinates of the cell.
  def look_down_from(coordinates)
    new_coordinates = [coordinates[0] + 1, coordinates[1]]
    return nil if new_coordinates[0] >= @trail_map.length
    {value: @trail_map[new_coordinates[0]][new_coordinates[1]], coordinates: new_coordinates}
  end

  # Look left from a given set of coordinates.
  # If the new coordinates are out of bounds, return nil.
  # If the new coordinates are in bounds, return the value and coordinates of the cell.
  #
  # @param coordinates [Array<Integer>] The coordinates to look left from.
  #
  # @return [Hash<Symbol, Object>] The value and coordinates of the cell.
  def look_left_from(coordinates)
    new_coordinates = [coordinates[0], coordinates[1] - 1]
    return nil if new_coordinates[1] < 0
    {value: @trail_map[new_coordinates[0]][new_coordinates[1]], coordinates: new_coordinates}
  end

  # Look right from a given set of coordinates.
  # If the new coordinates are out of bounds, return nil.
  # If the new coordinates are in bounds, return the value and coordinates of the cell.
  #
  # @param coordinates [Array<Integer>] The coordinates to look right from.
  #
  # @return [Hash<Symbol, Object>] The value and coordinates of the cell.
  def look_right_from(coordinates)
    new_coordinates = [coordinates[0], coordinates[1] + 1]
    return nil if new_coordinates[1] >= @trail_map[0].length
    {value: @trail_map[new_coordinates[0]][new_coordinates[1]], coordinates: new_coordinates}
  end

  # Load the input from a file.
  #
  # @param input [String] The name of the file to load.
  #
  # @return [nil]
  def load_input(input)
    AdventHelpers.load_input_and_do(input) do |line|
      load_map_row(line.strip)
    end
  end
end

# Example usage
if __FILE__ == $PROGRAM_NAME
  hoof_it = HoofIt.new
  hoof_it.load_input('day_10.txt')
  score = hoof_it.score_map
  Engine::Logger.info "The score of the map is [#{score}]"
  rating = hoof_it.rate_map
  Engine::Logger.info "The rating of the map is [#{rating}]"
end