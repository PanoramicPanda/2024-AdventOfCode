class Template
  def initialize
    AdventHelpers.print_christmas_header(10, 'Hoof It')
    @trail_map = []
  end

  def load_map_row(row)
    @trail_map << row.split('')
  end

  def load_input(input)
    AdventHelpers.load_input_and_do(input) do |line|
      load_map_row(line)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  t = Template.new
  t.load_input('input/puzzle_input.txt')
end