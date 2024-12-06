require_relative '../puzzles/day_06'

RSpec.describe GuardGallivant do

  example = <<-EXAMPLE
          ....#.....
          .........#
          ..........
          ..#.......
          .......#..
          ..........
          .#..^.....
          ........#.
          #.........
          ......#...
  EXAMPLE

  solver = GuardGallivant.new
  example.each_line do |line|
    solver.add_row(line)
  end
  solver.save_original_map
  location = solver.get_guard_location
  facing = solver.get_guard_facing
  target = solver.get_guard_target(solver.get_guard_location)
  solver.track_guard

  it 'Sees the guard at 6, 4' do
    expect(location).to eq([6, 4])
  end

  it 'Sees the guard is pointing ^: [-1,0]' do
    expect(facing).to eq([-1, 0])
  end

  it 'Sees the guard is looking at an empty space' do
    expect(target).to eq('.')
  end

  it 'Tracks the guards 41 positions before they leave' do
    expect(solver.guard_positions.count).to eq(41)
  end

end