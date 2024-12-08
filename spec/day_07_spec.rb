require_relative '../puzzles/day_07'

RSpec.describe BridgeRepair do

  sample_input = <<-SAMPLE_INPUT
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
  SAMPLE_INPUT
  solver = BridgeRepair.new
  solver.load_input(sample_input)


  it 'loads the numbers correctly' do
    expect(solver.calibrations[190]).to eq([10,19])
  end

  it 'determines if it can be evaluated correctly' do
    expect(solver.can_eval?(190)).to eq(true)
    expect(solver.can_eval?(83)).to eq(false)
  end

  it 'sums the correct evaluations correctly' do
    expect(solver.sum_correct_evaluations).to eq(3749)
  end

  it 'performs concatenation correctly' do
    expect(solver.can_eval?(156, concat: true)).to eq(true)
  end

  it 'sums the correct evaluations with concatenation correctly' do
    expect(solver.sum_correct_evaluations(concat: true)).to eq(11387)
  end

end