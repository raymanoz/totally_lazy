require_relative 'spec_helper'

describe 'Sequence' do
  it 'should create empty sequence when iterable is nil' do
    expect(sequence(nil)).to eq(empty)
  end

  it 'should support head' do
    expect(sequence(1,2).head).to eq(1)
  end

  it 'should return same result when head called many times' do
    expect(sequence(1,2).head).to eq(1)
    expect(sequence(1,2).head).to eq(1)
  end

  it 'should support head_option' do
    expect(sequence(1).head_option).to eq(some(1))
    expect(empty.head_option).to eq(none)
  end

  it 'should support reverse' do
    expect(sequence(1,2,3).reverse).to eq(sequence(3,2,1))
  end

  it 'should support last' do
    expect(sequence(1,2,3).last).to eq(3)
  end

  it 'should support last_option' do
    expect(sequence(1,2,3).last_option).to eq(some(3))
    expect(empty.last_option).to eq(none)
  end
end