# encoding: UTF-8

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

  it 'should support map_left' do
    expect(right(3).map_left(add(2))).to eq(right(3))
    expect(right(3).map_left { |a| a+2 }).to eq(right(3))
    expect(left(3).map_left(add(2))).to eq(left(5))
    expect(left(3).map_left { |a| a+2 }).to eq(left(5))
  end

  it 'should support flat_map' do
    expect(right(4).flat_map(divide(2).or_exception)).to eq(right(2))
    expect(right(4).flat_map { right(2) }).to eq(right(2))

    result = right(4).flat_map(divide(0).or_exception)
    expect(result.is_left?).to eq(true)
    expect(result.left_value.class).to eq(ZeroDivisionError)

    expect(left(2).flat_map(divide(2).or_exception)).to eq(left(2))
    expect(left(2).flat_map { right(5) }).to eq(left(2))
  end

  it 'should raise exception if you try to use both lambda and block' do
    expect { right(1).map(add(2)) { |a| a+2 } }.to raise_error(RuntimeError)
    expect { right(1).map_left(add(2)) { |a| a+2 } }.to raise_error(RuntimeError)
    expect { left(1).map_left(add(2)) { |a| a+2 } }.to raise_error(RuntimeError)
    expect { right(10).flat_map(divide(2)) { |a| a/2 } }.to raise_error(RuntimeError)
    expect { left(10).flat_map(divide(2)) { |a| a/2 } }.to raise_error(RuntimeError)
  end

end