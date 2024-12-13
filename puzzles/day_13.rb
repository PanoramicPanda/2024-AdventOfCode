require_relative '../utilities/advent_helpers'
require 'matrix'

# Day 13: Claw Contraption
#
# This class takes a list of claw machines and calculates the cost to obtain all prizes.
# The claw machines have two buttons, A and B, and a prize. The cost to press button A is 3 and the cost to press button B is 1.
class ClawContraption
  attr_reader :machines

  # Initialize the class with an empty array of machines.
  #
  # @return [ClawContraption] A new instance of ClawContraption.
  def initialize
    AdventHelpers.print_christmas_header(13, 'Claw Contraption')
    @machines = []
  end

  # Load the machines from the input.
  # If the row is not empty, create a new machine if the row contains 'Button A' or the machines array is empty.
  # Set the coordinates of the machine based on the type of row.
  #
  # @param row [String] The row to load.
  #
  # @return [nil]
  def load_machines(row)
    unless row.strip.empty?
      new_machine = row.include?('Button A') || @machines.empty?
      machine = new_machine ? ClawMachine.new : @machines.last
      if row.include?('Button')
        split = row.split(': ')
        type = split[0].strip
        x, y = split[1].split(', ')
        x = x.split('+')[1].to_i
        y = y.split('+')[1].to_i
      elsif row.include?('Prize')
        split = row.split(': ')
        type = split[0].strip
        x, y = split[1].split(', ')
        x = x.split('=')[1].to_i
        y = y.split('=')[1].to_i
      end
      machine.set_coordinate(type, x, y)
      @machines << machine if new_machine
    end
  end

  # Calculate the cost for all obtainable prizes.
  # The maximum number of presses is set to 100 by default.
  #
  # @param max_presses [Integer] The maximum number of presses allowed. Defaults to 100.
  #
  # @return [Integer] The cost to obtain all obtainable prizes.
  def cost_for_all_prizes(max_presses: 100)
    Engine::Logger.action 'Calculating the cost for all obtainable prizes...'
    @machines.map { |machine| machine.calculate_cheapest_prize(max_presses: max_presses) }.compact.sum { |solution| solution[:cost] }
  end

  # Load the input and create a new claw machine for each machine in the input.
  #
  # @param input [String] The input to load.
  #
  # @return [nil]
  def load_input(input)
    Engine::Logger.action 'Loading all machines...'
    AdventHelpers.load_input_and_do(input) do |line|
      load_machines(line)
    end
  end
end

# Represents a claw machine with two buttons and a prize.
# The cost to press button A is 3 and the cost to press button B is 1.
class ClawMachine
  attr_reader :button_a, :button_b, :prize

  # Initialize the claw machine with default values.
  # The buttons and prize are set to 0, 0.
  # The cost to press button A is 3 and the cost to press button B is 1.
  #
  # @return [ClawMachine] A new instance of ClawMachine.
  def initialize
    @button_a = {x: 0, y: 0}
    @button_b = {x: 0, y: 0}
    @prize = { x: 0, y: 0 }
    @cost_a = 3
    @cost_b = 1
  end

  # Set the coordinates of the claw machine.
  # The type is used to determine which coordinate to set.
  # The x and y coordinates are set based on the type.
  #
  # @param type [String] The type of coordinate to set.
  # @param x [Integer] The x coordinate to set.
  # @param y [Integer] The y coordinate to set.
  #
  # @return [nil]
  def set_coordinate(type, x, y)
    case type
    when 'Button A'
      @button_a[:x] = x
      @button_a[:y] = y
    when 'Button B'
      @button_b[:x] = x
      @button_b[:y] = y
    when 'Prize'
      @prize[:x] = x
      @prize[:y] = y
    end
  end

  # Calculate the cheapest prize for the claw machine.
  # The maximum number of presses is set to 100 by default.
  # If the maximum number of presses is nil, the presses are uncapped.
  #
  # Uses linear algebra to solve for the presses.
  # The coefficients are set based on the button costs.
  # The goals are set based on the prize coordinates.
  #
  # @param max_presses [Integer] The maximum number of presses allowed. Defaults to 100.
  #
  # @return [Hash<Symbol, Integer>, nil] The cheapest prize and the cost to obtain it. Returns nil if no solution is found.
  def calculate_cheapest_prize(max_presses: 100)
    prize_x = @prize[:x]
    prize_y = @prize[:y]

    # Adjust the prize for uncapped scenario
    if max_presses.nil?
      prize_x += 10_000_000_000_000
      prize_y += 10_000_000_000_000
      max_presses = Float::INFINITY
    end

    # Coefficient matrix
    coefficients = Matrix[
      [@button_a[:x], @button_b[:x]],
      [@button_a[:y], @button_b[:y]]
    ]

    # Goal vector
    goals = Vector[prize_x, prize_y]

    best_solution = nil
    min_cost = Float::INFINITY

    begin
      # Solve for the presses using linear algebra
      presses = coefficients.inverse * goals

      # Extract presses
      a_presses = presses[0]
      b_presses = presses[1]

      # Validate that both are whole numbers and within bounds
      if a_presses % 1 == 0 && b_presses % 1 == 0
        a_presses = a_presses.to_i
        b_presses = b_presses.to_i

        # Check validity of solution within bounds
        if a_presses >= 0 && b_presses >= 0 && a_presses <= max_presses && b_presses <= max_presses
          # Calculate the cost
          cost = (a_presses * @cost_a) + (b_presses * @cost_b)

          # Update the best solution if this is the cheapest
          if cost < min_cost
            min_cost = cost
            best_solution = { a_presses: a_presses, b_presses: b_presses, cost: cost }
          end
        end
      end
    rescue StandardError
      # Handle singular matrix or other errors
      best_solution = nil
    end

    best_solution
  end

end


# Example usage
if __FILE__ == $PROGRAM_NAME
  solver = ClawContraption.new
  solver.load_input('day_13.txt')
  cost = solver.cost_for_all_prizes
  Engine::Logger.info "The cost for all prizes is [#{cost}]"
  uncap_cost = solver.cost_for_all_prizes(max_presses: nil)
  Engine::Logger.info "The cost for all prizes with uncapped presses is [#{uncap_cost}]"
end