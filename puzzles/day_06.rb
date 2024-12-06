require_relative '../utilities/advent_helpers'

class GuardGallivant
  attr_reader :guard_positions

  def initialize
    @map = []
    @original_map = []
    @guard_facing = '^'
    @guard_positions = []
  end

  def add_row(row)
    @map << row.strip.split('')
  end

  def get_guard_facing
    facing_vectors[@guard_facing]
  end

  def get_guard_location
    guard_location = []
    @map.each_with_index do |row, row_index|
      row.each_with_index do |char, col_index|
        if char == "^" || char == "v" || char == "<" || char == ">"
          guard_location = [row_index, col_index]
          log_guard_position(guard_location) unless @guard_positions.include?(guard_location)
          @guard_facing = char
        end
      end
    end
    guard_location
  end

  def reset_map
    @map = @original_map.map(&:dup)
    @guard_positions = []
    @guard_facing = '^'
  end

  def is_previous_position?(position)
    @guard_positions.include?(position)
  end

  def log_guard_position(position)
    @guard_positions << position
  end

  def facing_vectors
    {
      '^' => [-1, 0],
      'v' => [1, 0],
      '<' => [0, -1],
      '>' => [0, 1]
    }
  end

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

  def get_guard_target(guard_location)
    target = guard_target_coordinates(guard_location)
    return 'Escape' if target[0] < 0 || target[0] >= @map.length || target[1] < 0 || target[1] >= @map[0].length
    @map[target[0]][target[1]]
  end

  def guard_target_coordinates(guard_location)
    guard_facing = get_guard_facing
    [guard_location[0] + guard_facing[0], guard_location[1] + guard_facing[1]]
  end

  def move_guard(old_position, new_position, facing)
    @map[old_position[0]][old_position[1]] = '.'
    @map[new_position[0]][new_position[1]] = facing
  end

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

  def load_input(input)
    AdventHelpers.load_file_and_do(input) do |line|
      add_row(line)
    end
    save_original_map
  end

  def save_original_map
    @original_map = @map.map(&:dup)
  end

end

if __FILE__ == $PROGRAM_NAME
  solver = GuardGallivant.new
  solver.load_input('day_06.txt')
  solver.track_guard
  puts "The guard visited #{solver.guard_positions.length} spots."
end