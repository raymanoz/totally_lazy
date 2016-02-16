require_relative 'spec_helper'

describe 'Sequence' do
  it 'should create empty sequence when iterable is nil' do
    expect(sequence(nil)).to eq(empty)
  end

  it 'should support head' do
    expect(sequence(1,2).head).to eq(1)
  end

  it 'should support head_option' do
    expect(sequence(1).head_option).to eq(some(1))
    expect(empty.head_option).to eq(none)
  end

end