require_relative '../puzzles/day_02'

RSpec.describe RedNosedReports do
  solver = RedNosedReports.new
  solver.add_report([7,6,4,2,1])
  solver.add_report([1,2,7,8,9])
  solver.add_report([9,7,6,2,1])
  solver.add_report([1,3,2,4,5])
  solver.add_report([8,6,4,4,1])
  solver.add_report([1,3,6,7,9])

  solver.load_initial_reports

  it 'finds the correct number of safe reports' do
    expect(solver.safe_report_count).to eq(2)
  end

  it 'dampens the correct number of reports' do
    solver.dampen_unsafe_reports
    expect(solver.safe_report_count).to eq(4)
  end

end