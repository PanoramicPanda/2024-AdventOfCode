require_relative '../day_03/day_03'

RSpec.describe MullItOver do
  example = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"



  it 'extracts the correct number of muls' do
    solver = MullItOver.new
    solver.extract_muls(example)
    expect(solver.muls.count).to eq(4)
  end

  it 'executes the muls correctly' do
    solver = MullItOver.new
    solver.extract_muls(example)
    solver.execute_all_muls
    expect(solver.mul_total).to eq(161)
  end

  it 'enables and disables mulling correctly' do
    solver = MullItOver.new
    solver.extract_only_enabled_muls(example)
    solver.execute_all_muls
    expect(solver.mul_total).to eq(48)
  end

end