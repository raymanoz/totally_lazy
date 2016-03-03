require_relative '../spec_helper'

describe 'Numbers' do
  it 'should support arbitrary multiply' do
    expect(sequence(1, 2, 3, 4, 5).map(multiply(5))).to eq(sequence(5, 10, 15, 20, 25))
  end

  it 'should treat multiply as a monoid' do
    expect(empty.reduce(multiply(5))).to eq(1)
  end

  it 'should be able to get powers_of a number' do
    expect(powers_of(3).take(10)).to eq(sequence(1, 3, 9, 27, 81, 243, 729, 2187, 6561, 19683))
  end
end
