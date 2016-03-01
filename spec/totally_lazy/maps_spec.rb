require_relative '../spec_helper'

describe 'Maps' do
  it 'should allow maps to be merged' do
    expect(merge(empty)).to eq({})
    expect(merge(sequence({1 => 2}, {3 => 4, 5 => 6}))).to eq({1 => 2, 3 => 4, 5 => 6})
    expect(merge(sequence({1 => 2, 3 => 3}, {3 => 4, 5 => 6}))).to eq({1 => 2, 3 => 4, 5 => 6})
  end
end