require_relative '../puzzles/day_05'

RSpec.describe PrintQueue do
  solver = PrintQueue.new
  input = <<-INPUT
  47|53
  97|13
  97|61
  97|47
  75|29
  61|13
  75|53
  29|13
  97|29
  53|29
  61|53
  97|53
  61|29
  47|13
  75|47
  97|75
  47|61
  75|61
  47|29
  75|13
  53|13

  75,47,61,53,29
  97,61,53,29,13
  75,29,13
  75,97,47,61,53
  61,13,29
  97,13,75,29,47
  INPUT

  input.each_line do |line|
    solver.add_to_queue(line.strip) if line.include?(',')
  end

  input.each_line do |line|
    solver.add_to_page_orders(line.strip) if line.include?('|')
  end
  solver.sort_orders_by_correctness

  it 'loads the correct number of print jobs' do
    expect(solver.queue.count).to eq(6)
  end

  it 'loads the correct number of page orders' do
    expect(solver.page_orders.count).to eq(21)
  end

  it 'totals the middle pages of correct print jobs' do
    expect(solver.get_middle_page_total_for_order(solver.correct_orders)).to eq(143)
  end

  it 'resorts the incorrect orders and returns the correct middle page total' do
    solver.resort_incorrect_orders
    expect(solver.get_middle_page_total_for_order(solver.incorrect_orders)).to eq(123)
  end
end