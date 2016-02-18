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

  it 'should support tail' do
    expect(sequence(1,2,3).tail).to eq(sequence(2,3))
  end

  it 'should lazily return tail' do
    expect(Sequence.new((1..Float::INFINITY).lazy).tail.head).to eq(2)
  end

  it 'should return empty tail on sequence with 1 item' do
    expect(sequence(1).tail).to eq(empty)
  end

  it 'should raise NoSuchElementException when getting a tail of empty' do
    expect{empty.tail}.to raise_error(NoSuchElementException)
  end

  it 'should support init' do
    expect(sequence(1,2,3).init).to eq(sequence(1,2))
  end

  it 'should raise NoSuchElementException when getting init of an empty' do
    expect{empty.init}.to raise_error(NoSuchElementException)
  end

  it 'should support map' do
    expect(sequence(1,2,3).map(->(a){a*2})).to eq(sequence(2,4,6))
  end

  it 'should support reduce_right' do
    # expect(sequence().reduce_right(sum)).to eq(0)   <-- need a monoid to do this
    expect(sequence(1).reduce_right(SUM)).to eq(1)
    expect(sequence(1,2).reduce_right(SUM)).to eq(3)
    expect(sequence(1,2,3).reduce_right(SUM)).to eq(6)
    # expect(sequence().reduce_right()).to eq('')    <-- need a monoid to do this
    expect(sequence("1").reduce_right(JOIN)).to eq("1")
    expect(sequence("1","2").reduce_right(JOIN)).to eq("12")
    expect(sequence("1","2","3").reduce_right(JOIN)).to eq("123")
  end
end