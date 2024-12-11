require_relative '../puzzles/day_11'

RSpec.describe PlutonianPebbles do

  solver = PlutonianPebbles.new
  example = "125 17\n"
  solver.load_input(example)

  it 'should find the correct number of stones' do
    expect(solver.count_stones).to eq(2)
  end

  it 'should blink once correctly' do
    solver.blink(1)
    expect(solver.count_stones).to eq(3)
  end

  it 'should blink 5 more times correctly' do
    solver.blink(5)
    expect(solver.count_stones).to eq(22)
  end

  it 'can blink 19 more times correctly' do
    solver.blink(19)
    expect(solver.count_stones).to eq(55312)
  end

end