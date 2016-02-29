require_relative '../spec_helper'

describe 'Either' do
  it 'should support filter and map' do
    eithers = sequence(left('error'), right(3))
    expect(eithers.filter(is_left?).map(get_left)).to eq(sequence('error'))
    expect(eithers.filter(is_right?).map(get_right)).to eq(sequence(3))
  end
end