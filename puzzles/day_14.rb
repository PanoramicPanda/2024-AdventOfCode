require_relative '../utilities/advent_helpers'
require 'chunky_png'

# Day 14: Restroom Redoubt
#
# Finds the number of drones in each quadrant of a grid and calculates the safety score
# based on the product of the number of drones in each quadrant.
class RestroomRedoubt
  attr_reader :drones

  # Initializes the drone tracking system with the given width and height.
  #
  # @param width [Integer] the width of the grid
  # @param height [Integer] the height of the grid
  #
  # @return [RestroomRedoubt] the drone tracking system
  def initialize(width, height)
    AdventHelpers.print_christmas_header(14, 'Restroom Redoubt')
    @width_max_index = width-1
    @height_max_index = height-1
    @middle_x = (width/2).floor
    @middle_y = (height/2).floor
    @drones = []
  end

  # Loads a drone from a row of input data.
  #
  # @param row [String] the row of input data
  #
  # @return [nil]
  def load_drone(row)
    drone = row.strip.split(' ')
    position = drone[0].split('=')[1].split(',')
    velocity = drone[1].split('=')[1].split(',')
    @drones << Drone.new(position[0].to_i, position[1].to_i,
                         velocity[0].to_i, velocity[1].to_i,
                         @width_max_index, @height_max_index)
  end

  # Moves all drones the given number of times.
  #
  # @param times [Integer] the number of times to move the drones
  #
  # @return [nil]
  def move_drones(times)
    Engine::Logger.action "Moving drones [#{times}] times..."
    times.times do
      @drones.each do |drone|
        drone.move
      end
    end
  end

  # Finds the number of drones in the given quadrant.
  #
  # @param quadrant [Symbol] the quadrant to search
  #
  # @return [Integer] the number of drones in the quadrant
  def find_drone_count_in_quadrant(quadrant)
    if quadrant == :top_left
      @drones.select { |drone| drone.x < @middle_x && drone.y < @middle_y }.length
    elsif quadrant == :top_right
      @drones.select { |drone| drone.x > @middle_x && drone.y < @middle_y }.length
    elsif quadrant == :bottom_left
      @drones.select { |drone| drone.x < @middle_x && drone.y > @middle_y }.length
    elsif quadrant == :bottom_right
      @drones.select { |drone| drone.x > @middle_x && drone.y > @middle_y }.length
    end
  end

  # Calculates the safety score based on the number of drones in each quadrant.
  #
  # @return [Integer] the safety score
  def calculate_safety_score
    top_left = find_drone_count_in_quadrant(:top_left)
    top_right = find_drone_count_in_quadrant(:top_right)
    bottom_left = find_drone_count_in_quadrant(:bottom_left)
    bottom_right = find_drone_count_in_quadrant(:bottom_right)
    top_left * top_right * bottom_left * bottom_right
  end

  # Loads the input data and creates drones from it.
  #
  # @param input [String] the input data
  #
  # @return [nil]
  def load_input(input)
    Engine::Logger.info 'Loading drones...'
    @drones = []
    AdventHelpers.load_input_and_do(input) do |line|
      load_drone(line)
    end
  end

  # Moves the drones the given number of times and generates images of the drone positions.
  #
  # @param times [Integer] the number of times to move the drones
  #
  # @return [nil]
  def move_and_print_drones(times)
    Engine::Logger.action "Moving drones [#{times}] times and generating images each time..."
    start_time = Time.now
    times.times do |time|
      @drones.each do |drone|
        drone.move
      end
      form_drones_as_grid_image(time)
    end
    end_time = Time.now
    Engine::Logger.info "Time taken: [#{end_time - start_time}] seconds"
  end

  # Generates an image of the drone positions at the given time.
  #
  # @param time [Integer] the time to generate the image
  #
  # @return [nil]
  def form_drones_as_grid_image(time)
    grid = Array.new(@height_max_index + 1) { Array.new(@width_max_index + 1, '.') }

    @drones.each do |drone|
      grid[drone.y][drone.x] = '#'
    end

    generate_image(grid, time+1)
  end

  # Generates an image from the given grid and time.
  #
  # @param grid [Array<Array<String>>] the grid to generate the image from
  # @param time [Integer] the time to generate the image
  #
  # @return [nil]
  def generate_image(grid, time)
    FileUtils.mkdir_p('images')

    pixel_size = 10
    rows = grid.length
    cols = grid[0].length

    filename = "images/drone_grid_time_#{time}.png"

    if File.exist?(filename)
      return
    end

    image = ChunkyPNG::Image.new(cols * pixel_size, rows * pixel_size, ChunkyPNG::Color::WHITE)

    grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        color = cell == '#' ? ChunkyPNG::Color::BLACK : ChunkyPNG::Color::WHITE
        (0...pixel_size).each do |dy|
          (0...pixel_size).each do |dx|
            image[x * pixel_size + dx, y * pixel_size + dy] = color
          end
        end
      end
    end

    image.save(filename)
  end

end

# Represents a drone in the grid.
class Drone
  attr_accessor :x, :y, :velocity_x, :velocity_y

  # Initializes the drone with the given position, velocity, and grid size.
  #
  # @param x [Integer] the x position of the drone
  # @param y [Integer] the y position of the drone
  # @param velocity_x [Integer] the x velocity of the drone
  # @param velocity_y [Integer] the y velocity of the drone
  # @param max_x [Integer] the maximum x position of the grid
  # @param max_y [Integer] the maximum y position of the grid
  #
  # @return [Drone] the drone
  def initialize(x, y, velocity_x, velocity_y, max_x, max_y)
    @x = x
    @y = y
    @velocity_x = velocity_x
    @velocity_y = velocity_y
    @max_x = max_x
    @max_y = max_y
  end

  # Moves the drone and wraps it around the grid if necessary.
  # If the drone goes off the grid, it wraps around to the other side.
  #
  # @return [nil]
  def move
    @x += @velocity_x
    @y += @velocity_y
    if @x > @max_x
      new_x = @x - @max_x - 1
      @x = new_x
    elsif @x < 0
      new_x = @max_x + @x + 1
      @x = new_x
    end
    if @y > @max_y
      new_y = @y - @max_y - 1
      @y = new_y
    elsif @y < 0
      new_y = @max_y + @y + 1
      @y = new_y
    end
  end
end

# Example usage
if __FILE__ == $PROGRAM_NAME
  solver = RestroomRedoubt.new(101, 103)
  solver.load_input('day_14.txt')
  solver.move_drones(100)
  Engine::Logger.info "The safety score is [#{solver.calculate_safety_score}]"
  # solver.load_input('day_14.txt')
  # solver.move_and_print_drones(10000)
end