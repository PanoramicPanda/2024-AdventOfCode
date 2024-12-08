require_relative '../utilities/advent_helpers'

# Day 4 - Ceres Search
#
# This class provides methods to search for strings in a grid, and count the number of times they appear.
# It also provides methods to search for strings in an x pattern, and count the number of times they appear.
class CeresSearch
  # Initializes a new instance of CeresSearch
  #
  # @return [nil]
  def initialize
    @grid = []
  end

  # Adds a row of characters to the grid
  #
  # @param row [String] The row to add as a string
  #
  # @return [nil]
  def add_string_row(row)
    @grid << row.chars
  end

  # Returns a hash of cardinal directions and their vectors
  #
  # @return [Hash] The hash of cardinal directions
  def cardinal_directions
    {
      up: [-1, 0],
      down: [1, 0],
      left: [0, -1],
      right: [0, 1]
    }
  end

  # Returns a hash of diagonal directions and their vectors
  #
  # @return [Hash] The hash of diagonal directions
  def diagonal_directions
    {
      up_left: [-1, -1],
      up_right: [-1, 1],
      down_left: [1, -1],
      down_right: [1, 1]
    }
  end

  # Counts the number of times a string appears in the grid
  # Does this by iterating over each character in the grid, and checking each direction for the string
  # Returns the count of the string
  #
  # @param string [String] The string to search for
  #
  # @return [Integer] The count of the string
  def count_of_string(string)
    count = 0
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |char, col_index|
        cardinal_directions.each do |direction, vector|
          count += 1 if search_string(string, row_index, col_index, vector)
        end
        diagonal_directions.each do |direction, vector|
          count += 1 if search_string(string, row_index, col_index, vector)
        end
      end
    end
    count
  end

  # Checks for the string in a direction given by a vector
  # Does this by checking each character in the string at the new row and column
  # Returns false if the new row or column is out of bounds, or if the character at the new row and column doesn't match the character in the string
  #
  # @param string [String] The string to search for
  # @param row [Integer] The row to start at
  # @param col [Integer] The column to start at
  # @param vector [Array] The vector to move in
  #
  # @return [Boolean] True if the string is found in the direction, false otherwise
  def search_string(string, row, col, vector)
    string.chars.each_with_index do |char, index|
      new_row = row + (vector[0] * index)
      new_col = col + (vector[1] * index)
      return false if new_row < 0 || new_col < 0 || new_row >= @grid.length || new_col >= @grid[0].length
      return false if @grid[new_row][new_col] != char
    end
    true
  end

  # Makes all possible combinations of a string and its reverse
  # This is to compare the string in all possible directions for x patterns
  #
  # @param string [String] The string to make combinations of
  #
  # @return [Array] An array of all possible combinations
  def flatten_x_combos(string)
    %W[#{string}#{string.reverse} #{string.reverse}#{string} #{string}#{string} #{string.reverse}#{string.reverse}]
  end

  # Given coordinates, returns the string in the direction of both diagonal vectors, starting at the top corners, as a flat string
  # Assumes the string is 3 characters long
  #
  # @param row [Integer] The row to start at
  # @param col [Integer] The column to start at
  #
  # @return [String] The flat string in the diagonal directions
  def grab_flat_x_at_letter(row, col)
    flat_x = ''
    flat_x += grab_x(row, col, diagonal_directions[:up_left], diagonal_directions[:down_right])
    flat_x += grab_x(row, col, diagonal_directions[:up_right], diagonal_directions[:down_left])
    flat_x
  end

  # Given coordinates, returns the string in the direction of both vectors
  # Assumes the string is 3 characters long
  # Returns an empty string if the new row or column is out of bounds
  #
  # @param row [Integer] The row to start at
  # @param col [Integer] The column to start at
  # @param vector_1 [Array] The first vector to move in
  # @param vector_2 [Array] The second vector to move in
  #
  # @return [String] The string in the direction of both vectors
  def grab_x(row, col, vector_1, vector_2)
    x = ''
    new_row_1 = row + vector_1[0]
    new_col_1 = col + vector_1[1]
    new_row_2 = row + vector_2[0]
    new_col_2 = col + vector_2[1]
    return x if new_row_1 < 0 || new_col_1 < 0 || new_row_1 >= @grid.length || new_col_1 >= @grid[0].length
    return x if new_row_2 < 0 || new_col_2 < 0 || new_row_2 >= @grid.length || new_col_2 >= @grid[0].length
    x += @grid[new_row_1][new_col_1]
    x += @grid[row][col]
    x += @grid[new_row_2][new_col_2]
    x
  end

  # Counts the number of times a string appears in the grid in an x pattern
  # Uses flatten_x_combos to get all possible combinations of the string and its reverse
  # Does this by iterating over each character in the grid, and checking each direction for the string
  # But only if the character at the current row and column is the second character in the string
  # Assumes the string is 3 characters long
  #
  # @param string [String] The string to search for
  #
  # @return [Integer] The count of the string in an x pattern
  def count_of_x_pattern(string)
    count = 0
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |char, col_index|
        next if @grid[row_index][col_index] != string[1]
        x_combos = flatten_x_combos(string)
        count += 1 if x_combos.include?(grab_flat_x_at_letter(row_index, col_index))
      end
    end
    count
  end


  # Loads a crossword from a file
  # Does this by loading the file and adding each line to the grid
  #
  # @param filename [String] The name of the file to load
  #
  # @return [nil]
  def load_crossword(filename)
    AdventHelpers.load_input_and_do(filename) do |line|
      add_string_row(line)
    end
  end

end

# Example usage
if __FILE__ == $PROGRAM_NAME
  solver = CeresSearch.new
  solver.load_crossword('day_04.txt')
  puts "XMAS Count: #{solver.count_of_string('XMAS')}"
  puts "X-MAS Count: #{solver.count_of_x_pattern('MAS')}"
end