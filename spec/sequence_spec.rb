require_relative 'spec_helper'

describe 'Sequence' do
  it 'should create empty sequence when iterable is nil' do
    expect(sequence(nil)).to eq(empty)
  end
end