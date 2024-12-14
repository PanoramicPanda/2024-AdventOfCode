require_relative '../puzzles/day_14'

RSpec.describe RestroomRedoubt do
  example = <<-EXAMPLE
    p=0,4 v=3,-3
    p=6,3 v=-1,-3
    p=10,3 v=-1,2
    p=2,0 v=2,-1
    p=0,0 v=1,3
    p=3,0 v=-2,-2
    p=7,6 v=-1,-3
    p=3,0 v=-1,-2
    p=9,3 v=2,3
    p=7,3 v=-1,2
    p=2,4 v=2,-3
    p=9,5 v=-3,-3
  EXAMPLE

  solver = RestroomRedoubt.new(11, 7)
  solver.load_input(example)
  solver.move_drones(100)

  it 'loads the drones correctly' do
    expect(solver.drones.length).to eq(12)
  end

  it 'finds the drones in the correct quadrants' do
    expect(solver.find_drone_count_in_quadrant(:top_left)).to eq(1)
    expect(solver.find_drone_count_in_quadrant(:top_right)).to eq(3)
    expect(solver.find_drone_count_in_quadrant(:bottom_left)).to eq(4)
    expect(solver.find_drone_count_in_quadrant(:bottom_right)).to eq(1)
  end

  it 'calculates the safety score correctly' do
    expect(solver.calculate_safety_score).to eq(12)
  end
end