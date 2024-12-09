require_relative '../puzzles/day_09'

RSpec.describe DiskFragmenter do

  example = "2333133121414131402\n"

  solver = DiskFragmenter.new


  it 'gets the string representation of the fragment correct' do
    solver.load_input(example)
    string = solver.string_representation
    expect(string).to eq("00...111...2...333.44.5555.6666.777.888899")
  end

  it 'can defragment the disk correctly' do
    solver.load_input(example)
    solver.defragment
    defragmented = solver.string_representation
    expect(defragmented).to eq("0099811188827773336446555566..............")
  end

  it 'can calculate the standard defragment checksum correctly' do
    solver.load_input(example)
    solver.defragment
    checksum = solver.checksum
    expect(checksum).to eq(1928)
  end

  it 'can defragment the disk correctly when using the contiguous regions' do
    solver.load_input(example)
    solver.defragment(contiguous: true)
    defragmented = solver.string_representation
    expect(defragmented).to eq("00992111777.44.333....5555.6666.....8888..")
  end

  it 'checksums the defragmented disk correctly when using the contiguous regions' do
    solver.load_input(example)
    solver.defragment(contiguous: true)
    checksum = solver.checksum
    expect(checksum).to eq(2858)
  end

end