require_relative '../puzzles/day_10'

RSpec.describe HoofIt do
  solver = HoofIt.new
  example = <<-EXAMPLE
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
  EXAMPLE
  solver.load_input(example)
  solver.find_trailheads
  solver.make_map

  it 'should find the correct trailheads' do
    expect(solver.list_trailheads).to eq([[0,2], [0,4], [2, 4], [4,6], [5,2], [5,5], [6,0], [6,6], [7,1]])
  end

  it 'can find a single trail from [5,2]' do
    expect(solver.find_trails([5,2], 9)).to eq([[[5,2],[5,3],[6,3],[6,2],[7,2],[7,3],[7,4],[7,5],[6,5],[6,4]]])
  end

  it 'finds 4 trails from [5,5]' do
    expect(solver.find_trails([5,5],9).length).to eq(4)
  end

  it 'gives trailhead [5,5] a score of 3' do
    expect(solver.score_trailhead([5,5])).to eq(3)
  end

  it 'gives the map a score of 36' do
    expect(solver.score_map).to eq(36)
  end

  it 'gives a map rating of 81' do
    expect(solver.rate_map).to eq(81)
  end

end