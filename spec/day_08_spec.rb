require_relative '../puzzles/day_08'

RSpec.describe ResonantCollinearity do

  example = <<-EXAMPLE
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
  EXAMPLE
  solver = ResonantCollinearity.new
  solver.load_input(example)

  it 'finds the distance between two coordinates correctly' do
    expect(solver.find_distance([1, 1], [1, 1])).to eq([0, 0])
    expect(solver.find_distance([1, 1], [1, 2])).to eq([0, 1])
    expect(solver.find_distance([1, 1], [2, 2])).to eq([1, 1])
    expect(solver.find_distance([1, 1], [2, 1])).to eq([1, 0])
    expect(solver.find_distance([2, 1], [1, 1])).to eq([1, 0])
  end

  it 'determines the relative position of the antinode correctly' do
    expect(solver.determine_antinode_relative_position([2, 5], [4, 4], [2, 1])).to eq([-2, 1])
    expect(solver.determine_antinode_relative_position([2, 5], [1, 1], [1, 4])).to eq([1, 4])
    expect(solver.determine_antinode_relative_position([1, 1], [2, 5], [2, 1])).to eq([-2, -1])
  end

  it 'determines the position of the antinode correctly' do
    expect(solver.determine_antinode_position([2, 5], [-2, 1])).to eq([0, 6])
    expect(solver.determine_antinode_position([2, 5], [1, -4])).to eq([3, 1])
    expect(solver.determine_antinode_position([1, 1], [2, -1])).to eq([3, 0])
  end

  it 'places two antinodes correctly' do
    solver.place_antinodes([2, 5], [4, 4])
    expect(solver.antinode_map[0][6]).to eq('#')
    expect(solver.antinode_map[6][3]).to eq('#')
  end

  it 'can place all antinodes' do
    solver.place_all_antinodes
    expect(solver.count_antinodes).to eq(14)
  end

  it 'can place the resonant haromonies correctly' do
    solver.place_resonant_antinodes
    expect(solver.count_antinodes).to eq(34)
  end


end