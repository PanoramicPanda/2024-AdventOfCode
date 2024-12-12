require_relative '../puzzles/day_12'

RSpec.describe GardenGroups do
  example = <<-EXAMPLE
      RRRRIICCFF
      RRRRIICCCF
      VVRRRCCFFF
      VVRCCCJFFF
      VVVVCJJCFE
      VVIVCCJJEE
      VVIIICJJEE
      MIIIIIJJEE
      MIIISIJEEE
      MMMISSJEEE
  EXAMPLE
  solver = GardenGroups.new
  solver.load_input(example)
  solver.create_region_map

  it 'loads the garden map correctly' do
    expect(solver.garden_map[0][0]).to eq('R')
    expect(solver.garden_map[9][9]).to eq('E')
  end

  it 'Can see the correct amount of like and unlike neighbors' do
    neighbors = solver.find_neighbors(0,0)
    expect(neighbors[:like].length).to eq(2)
    expect(neighbors[:unalike].length).to eq(2)
    neighbors = solver.find_neighbors(2,5)
    expect(neighbors[:like].length).to eq(2)
    expect(neighbors[:unalike].length).to eq(2)
  end

  it 'Can generate a correct region map' do
    region = solver.region_map[0]
    expect(region.crop).to eq('R')
    expect(region.area).to eq(12)
    expect(region.perimeter).to eq(18)
    expect(region.price).to eq(216)
  end

  it 'Prices the entire garden correctly' do
    expect(solver.price_garden).to eq(1930)
  end

  it 'Can find the number of corners for a region' do
    region = solver.region_map[0]
    expect(region.corners).to eq(10)
    expect(region.bulk_price).to eq(120)
  end

  it 'Can bulk price the garden' do
    expect(solver.bulk_price_garden).to eq(1206)
  end



  it 'can bulk price the new garden' do
    example = <<-EXAMPLE
        AAAAAA
        AAABBA
        AAABBA
        ABBAAA
        ABBAAA
        AAAAAA
    EXAMPLE
    solver = GardenGroups.new
    solver.load_input(example)
    solver.create_region_map
    expect(solver.bulk_price_garden).to eq(368)
  end


end