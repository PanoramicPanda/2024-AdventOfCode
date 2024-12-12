require_relative '../utilities/advent_helpers'

# Day 12: Garden Groups
# The GardenGroups class is used to find the total price of garden fencing.
# The garden is divided into regions, and the price of the garden is calculated based on the area and perimeter of each region.
# The class can also calculate the bulk price of the garden, which is based on the area and number of sides in each region.
class GardenGroups
  attr_reader :garden_map, :region_map

  # Initializes the GardenGroups class.
  # Sets the garden map and region map to empty arrays.
  #
  # @return [GardenGroups] The GardenGroups class.
  def initialize
    AdventHelpers.print_christmas_header(12, 'Garden Groups')
    @garden_map = []
    @region_map = []
  end

  # Loads a row of the garden map.
  #
  # @param row [String] The row to load.
  def load_map_row(row)
    @garden_map << row.strip.split('')
  end

  # Creates the region map by finding contiguous regions in the garden map.
  #
  # @return [nil]
  def create_region_map
    time = Time.now
    Engine::Logger.action 'Creating region map...'
    visited = {}

    @garden_map.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        next if visited[[y,x]]

        region_cells, like_unlike_map = find_contiguous_region_for_cell(y, x, visited)
        unless region_cells.empty?
          @region_map << CropRegion.new(cell, region_cells, like_unlike_map)
        end
      end
    end

    time_diff = ((Time.now - time) * 1000).round(3)
    Engine::Logger.info "Region map created in [#{time_diff}] seconds."
  end


  # Finds a contiguous region for a cell in the garden map.
  # Uses a breadth-first search to find all cells in the region.
  #
  # @param y [Integer] The y-coordinate of the cell.
  # @param x [Integer] The x-coordinate of the cell.
  # @param visited [Hash] A hash to store visited cells, to prevent revisiting cells.
  #
  # @return [Array<Array<Integer>, Hash>] The region and the like/unlike map
  def find_contiguous_region_for_cell(y, x, visited)
    region = []
    like_unlike_map = {}
    queue = [[y, x]]
    initial_cell = @garden_map[y][x]

    until queue.empty?
      y, x = queue.shift
      next if visited[[y, x]]

      visited[[y, x]] = true
      region << [y, x]

      neighbors = find_neighbors(y, x)
      like_unlike_map[[y, x]] = neighbors

      neighbors[:like].each do |neighbor|
        new_y, new_x = neighbor
        queue << [new_y, new_x] unless visited[[new_y, new_x]]
      end

    end
    [region, like_unlike_map]
  end

  # Finds the neighbors of a cell in the garden map.
  # Separates neighbors into like and unlike neighbors.
  #
  # @param y [Integer] The y-coordinate of the cell.
  # @param x [Integer] The x-coordinate of the cell.
  #
  # @return [Hash] The neighbors of the cell.
  def find_neighbors(y, x)
    neighbors = { like: [], unalike: [] }
    current = @garden_map[y][x]

    [[y-1, x], [y+1, x], [y, x-1], [y, x+1]].each do |new_y, new_x|
      if valid_coords?(new_y, new_x)
        neighbor_value = @garden_map[new_y][new_x]
        if neighbor_value == current
          neighbors[:like] << [new_y, new_x]
        else
          neighbors[:unalike] << [new_y, new_x]
        end
      else
        neighbors[:unalike] << [new_y, new_x]
      end
    end

    neighbors
  end

  # Checks if a cell is already logged in the region map.
  #
  # @param y [Integer] The y-coordinate of the cell.
  # @param x [Integer] The x-coordinate of the cell.
  #
  # @return [Boolean] True if the cell is in the region map, false otherwise.
  def is_cell_in_region_map?(y, x)
    @region_map.each do |region|
      region.region.each do |cell|
        return true if cell == [y, x]
      end
    end
    false
  end

  # Calculates the total price of fencing for the garden.
  #
  # @return [Integer] The total price of fencing for the garden.
  def price_garden
    @region_map.map(&:price).sum
  end

  # Calculates the total bulk price of fencing for the garden.
  #
  # @return [Integer] The total bulk price of fencing.
  def bulk_price_garden
    @region_map.map(&:bulk_price).sum
  end

  # Loads the input for the puzzle.
  #
  # @param input [String] The input for the puzzle.
  #
  # @return [nil]
  def load_input(input)
    AdventHelpers.load_input_and_do(input) do |line|
      load_map_row(line)
    end
  end

  private
  def valid_coords?(y, x)
    y.between?(0, @garden_map.length - 1) && x.between?(0, @garden_map[y].length - 1)
  end

end

# The CropRegion class is used to store information about a region of crops in the garden.
# The class calculates the area, perimeter, price, corners, and bulk price of the region.
class CropRegion
  attr_accessor :crop, :region, :area, :like_unalike_map, :perimeter, :price, :corners, :bulk_price

  # Initializes the CropRegion class.
  # Calculates the area, perimeter, price, corners, and bulk price of the region.
  #
  # @param crop [String] The crop in the region.
  # @param region [Array<Array<Integer>>] The region of the crop.
  # @param like_unalike_map [Hash] The like/unlike map of the region.
  #
  # @return [CropRegion] The CropRegion class.
  def initialize(crop, region, like_unalike_map)
    @crop = crop
    @region = region
    @like_unalike_map = like_unalike_map
    calculate_total_area
    calculate_perimeter
    calculate_price
    calculate_corners
    calculate_bulk_price
  end

  # Calculates the total area of the region.
  # The area is the number of cells in the region.
  #
  # @return [integer] The total area of the region.
  def calculate_total_area
    @area = @region.length
  end

  # Calculates the perimeter of the region.
  # The perimeter is the number of unlike neighbors of the region.
  #
  # @return [integer] The perimeter of the region.
  def calculate_perimeter
    perimeter = 0
    @like_unalike_map.each do |cell, neighbors|
      perimeter += neighbors[:unalike].length
    end
    @perimeter = perimeter
  end

  # Calculates the price of fencing the region.
  # The price is the area multiplied by the perimeter.
  #
  # @return [integer] The price of fencing the region.
  def calculate_price
    @price = @area * @perimeter
  end

  # Calculates the number of corners in the region.
  # We use this to determine how many sides the region has.
  #
  # A corner is a cell that is not in the region, but has two adjacent cells that are in the region.
  # Or a cell that is in the region, but has two adjacent cells that are not in the region.
  #
  # @return [integer] The number of corners in the region.
  def calculate_corners
    @corners = 0
    diagonals = [
      { diag: [-1, -1], adj: [[-1, 0], [0, -1]] }, # Top-left
      { diag: [-1, 1], adj: [[-1, 0], [0, 1]] },  # Top-right
      { diag: [1, -1], adj: [[1, 0], [0, -1]] },  # Bottom-left
      { diag: [1, 1], adj: [[1, 0], [0, 1]] }     # Bottom-right
    ]

    @region.each do |y, x|
      diagonals.each do |diagonal_info|
        diag_coords = [y + diagonal_info[:diag][0], x + diagonal_info[:diag][1]]
        adj_coords = diagonal_info[:adj].map { |dy, dx| [y + dy, x + dx] }

        diag_in_region = @region.include?(diag_coords)

        adj_in_region = adj_coords.map { |adj| @region.include?(adj) }

        # Case 1: Outer corner
        # Diagonal is not in the region, and both adjacents are not in the region
        if !diag_in_region && adj_in_region.none?
          @corners += 1
        end

        # Case 2: Inner corner
        # Diagonal is in the region, but both adjacents are not in the region
        if diag_in_region && adj_in_region.none?
          @corners += 1
        end

        # Case 3: Weird Corner
        # Diagonal is not in the region, but both adjacents are in the region
        if !diag_in_region && adj_in_region.all?
          @corners += 1
        end
      end
    end
  end

  # Calculates the bulk price of fencing the region.
  # The bulk price is the area multiplied by the number of corners.
  #
  # @return [integer] The bulk price of fencing the region.
  def calculate_bulk_price
    @bulk_price = @area * @corners
  end

end

# Example Usage
if __FILE__ == $PROGRAM_NAME
  solver = GardenGroups.new
  solver.load_input('day_12.txt')
  solver.create_region_map
  Engine::Logger.info "The total price of the garden is: [#{solver.price_garden}]"
  Engine::Logger.info "The total bulk price of the garden is: [#{solver.bulk_price_garden}]"
end