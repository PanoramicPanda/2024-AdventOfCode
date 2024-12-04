require_relative '../puzzles/day_01'

RSpec.describe HistorianHysteria do
  solver = HistorianHysteria.new
  solver.array_1 = [3,4,2,1,3,3]
  solver.array_2 = [4,3,5,3,9,3]

  it 'finds the distances correctly' do
    expect(solver.get_total_distance).to eq(11)
  end

  it 'calculates the similarity score correctly' do
    expect(solver.get_similarity_score).to eq(31)
  end

end