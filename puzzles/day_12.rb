require_relative '../utilities/advent_helpers'

class GardenGroups
  attr_reader :garden_map, :region_map

  def initialize
    AdventHelpers.print_christmas_header(12, 'Garden Groups')
    @garden_map = []
    @region_map = []
  end

  def load_map_row(row)
    @garden_map << row.strip.split('')
  end

  def create_region_map
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

  end


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

  def is_cell_in_region_map?(y, x)
    @region_map.each do |region|
      region.region.each do |cell|
        return true if cell == [y, x]
      end
    end
    false
  end

  def price_garden
    @region_map.map(&:price).sum
  end

  def bulk_price_garden
    @region_map.map(&:bulk_price).sum
  end

  def load_input(input)
    AdventHelpers.load_input_and_do(input) do |line|
      load_map_row(line)
    end
  end

  def valid_coords?(y, x)
    y.between?(0, @garden_map.length - 1) && x.between?(0, @garden_map[y].length - 1)
  end

end

class CropRegion
  attr_accessor :crop, :region, :area, :like_unalike_map, :perimeter, :price, :corners, :bulk_price

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

  def calculate_total_area
    @area = @region.length
  end

  def calculate_perimeter
    perimeter = 0
    @like_unalike_map.each do |cell, neighbors|
      perimeter += neighbors[:unalike].length
    end
    @perimeter = perimeter
  end

  def calculate_price
    @price = @area * @perimeter
  end

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

        # Check if the diagonal is part of the same region
        diag_in_region = @region.include?(diag_coords)

        # Check if adjacent cells are part of the same region
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

        # Case 3
        # Diagonal is not in the region, but both adjacents are in the region
        if !diag_in_region && adj_in_region.all?
          @corners += 1
        end
      end
    end
  end




  def calculate_bulk_price
    @bulk_price = @area * @corners
  end

end

if __FILE__ == $PROGRAM_NAME
  solver = GardenGroups.new
  solver.load_input('day_12.txt')
  solver.create_region_map
  Engine::Logger.info "The total price of the garden is: [#{solver.price_garden}]"
  Engine::Logger.info "The total bulk price of the garden is: [#{solver.bulk_price_garden}]"
end