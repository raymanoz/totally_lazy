require_relative '../spec_helper'

describe 'Either' do
  it 'can be used in filter and map' do
    eithers = sequence(left('error'), right(3))
    expect(eithers.filter(is_left?).map(get_left)).to eq(sequence('error'))
    expect(eithers.filter(is_right?).map(get_right)).to eq(sequence(3))
  end

  it 'should support map' do
    expect(right(3).map(add(2))).to eq(right(5))
    expect(right(3).map { |a| a+2 }).to eq(right(5))
    expect(left(3).map_lr(add(2), nil)).to eq(5)
    expect(right(3).map_lr(nil, add(2))).to eq(5)
  end

  it 'should raise exception if you try to use both lambda and block' do
    expect { right(1).map(add(2)) { |a| a+2 } }.to raise_error(RuntimeError)
  end
end