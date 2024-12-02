# Day 1 - Historian Hysteria
#
# This class provides methods to calculate distances and similarity scores between elements of two arrays.
class HistorianHysteria
  attr_accessor :array_1, :array_2

  # Initializes a new instance of HistorianHysteria.
  def initialize
    @array_1 = []
    @array_2 = []
    @distances = []
    @similarity_scores = []
  end

  # Calculates the absolute distances between numbers at the same positions in two arrays.
  # @return [nil]
  def calculate_distances
    check_arrays
    sorted_array_1 = @array_1.sort
    sorted_array_2 = @array_2.sort
    sorted_array_1.each_with_index do |location, index|
      @distances << (location - sorted_array_2[index]).abs
    end
  end

  # Calculates how many times a number in array one shows up in array two, and then multiplies it by the count.
  # @return [nil]
  def calculate_similarity_scores
    check_arrays
    @array_1.each do |location|
      count = @array_2.count(location)
      @similarity_scores << location * count
    end
  end

  # Calculate the distances and return the sum.
  # @return [Integer] The total distance
  def get_total_distance
    calculate_distances
    @distances.sum
  end

  # Calculate the similarity scores and return the sum.
  # @return [Integer] The similarity score
  def get_similarity_score
    calculate_similarity_scores
    @similarity_scores.sum
  end

  # Loads the input file, and adds each line to the arrays.
  #
  # @param input_file [String] The name of the input file. Expected to be in the same directory as this file.
  # @return [nil]
  def load_input(input_file)
    file = File.open(File.expand_path(input_file, __dir__), "r")
    file.readlines.each do |line|
      if line.length > 2
        split_line = line.split(" ")
        @array_1 << split_line[0].to_i
        @array_2 << split_line[1].to_i
      end
    end
  end

  # Checks that the arrays are the same length to make sure we formatted them correctly.
  # Raises an error if they are not.
  # @raise [RuntimeError] If the arrays are not the same length.
  # @return [nil]
  def check_arrays
    if @array_1.length != @array_2.length
      Logger.raise 'Arrays are not the same length!'
    end
  end
end

# Example Usage
if __FILE__ == $0
  solver = HistorianHysteria.new
  solver.load_input('input.txt')
  puts "The total distance is: #{solver.get_total_distance}"
  puts "The similarity score is: #{solver.get_similarity_score}"
end