# This file contains helper methods for Advent of Code problems.
# Some functionality is shared between problems, so it is placed here to avoid duplication.
module AdventHelpers

  # Loads input and processes it to the yielded block line by line.
  # If the input is a filename, it is loaded from the inputs directory.
  # If the input is a heredoc string, it is processed directly.
  #
  # @param input_file [String] The name of the input file.
  # @yield [String] Each line in the file.
  # @return [nil]
  def self.load_input_and_do(input, &block)
    if input.include?("\n")
      input.each_line do |line|
        block.call(line)
      end
      return
    end
    path = File.expand_path('../inputs', __dir__)
    full_path = File.join(path, input)
    file = File.open(full_path, "r")
    file.readlines.each do |line|
      block.call(line) if line.strip.length > 0
    end
  end

end