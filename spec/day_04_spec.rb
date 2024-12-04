require_relative '../day_04/day_04'


RSpec.describe CeresSearch do
  solver = CeresSearch.new
  solver.add_string_row('MMMSXXMASM')
  solver.add_string_row('MSAMXMSMSA')
  solver.add_string_row('AMXSXMAAMM')
  solver.add_string_row('MSAMASMSMX')
  solver.add_string_row('XMASAMXAMM')
  solver.add_string_row('XXAMMXXAMA')
  solver.add_string_row('SMSMSASXSS')
  solver.add_string_row('SAXAMASAAA')
  solver.add_string_row('MAMMMXMMMM')
  solver.add_string_row('MXMXAXMASX')

  it 'can find 18 instances of the word "XMAS"' do
    expect(solver.count_of_string('XMAS')).to eq(18)
  end

  it 'can find 9 instances of an X pattern of the word "MAS"' do
    expect(solver.count_of_x_pattern('MAS')).to eq(9)
  end

end