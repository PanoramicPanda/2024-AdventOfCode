require_relative '../puzzles/day_13'

describe ClawContraption do

  example = <<-EXAMPLE
      Button A: X+94, Y+34
      Button B: X+22, Y+67
      Prize: X=8400, Y=5400
      
      Button A: X+26, Y+66
      Button B: X+67, Y+21
      Prize: X=12748, Y=12176
      
      Button A: X+17, Y+86
      Button B: X+84, Y+37
      Prize: X=7870, Y=6450
      
      Button A: X+69, Y+23
      Button B: X+27, Y+71
      Prize: X=18641, Y=10279
  EXAMPLE
  solver = ClawContraption.new
  solver.load_input(example)

  it 'loads the machines' do
    expect(solver.machines.length).to eq(4)
    expect(solver.machines[0].button_a).to eq({x: 94, y: 34})
    expect(solver.machines[0].button_b).to eq({x: 22, y: 67})
    expect(solver.machines[0].prize).to eq({x: 8400, y: 5400})
  end

  it 'Calculates the cheapest prize of the first machine correctly' do
    expect(solver.machines[0].calculate_cheapest_prize).to eq({a_presses: 80, b_presses: 40, cost: 280})
  end

  it 'Calculates we cannot win the prize of the second machine' do
    expect(solver.machines[1].calculate_cheapest_prize).to eq(nil)
  end

  it 'Calculates all the prizes correctly' do
    expect(solver.cost_for_all_prizes).to eq(480)
  end

  it 'Calculates uncapped presses correctly' do
    expect(solver.cost_for_all_prizes(max_presses: nil)).to eq(875318608908)
  end

end