# This file contains helper methods for Advent of Code problems.
# Some functionality is shared between problems, so it is placed here to avoid duplication.
module AdventHelpers

  # Loads a file from the inputs directory and yields each line to the block.
  #
  # @param input_file [String] The name of the input file.
  # @yield [String] Each line in the file.
  # @return [nil]
  def self.load_file_and_do(input_file, &block)
    path = File.expand_path('../inputs', __dir__)
    full_path = File.join(path, input_file)
    file = File.open(full_path, "r")
    file.readlines.each do |line|
      block.call(line) if line.strip.length > 0
    end
  end

end