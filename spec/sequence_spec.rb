require_relative 'spec_helper'

describe 'Sequence' do
  it 'should create empty sequence when iterable is nil' do
    expect(sequence(nil)).to eq(empty)
  end

  it 'should support head' do
    expect(sequence(1, 2).head).to eq(1)
  end

  it 'should return same result when head called many times' do
    expect(sequence(1, 2).head).to eq(1)
    expect(sequence(1, 2).head).to eq(1)
  end

  it 'should support head_option' do
    expect(sequence(1).head_option).to eq(some(1))
    expect(empty.head_option).to eq(none)
  end

  it 'should support reverse' do
    expect(sequence(1, 2, 3).reverse).to eq(sequence(3, 2, 1))
  end

  it 'should support last' do
    expect(sequence(1, 2, 3).last).to eq(3)
  end

  it 'should support last_option' do
    expect(sequence(1, 2, 3).last_option).to eq(some(3))
    expect(empty.last_option).to eq(none)
  end

  it 'should support tail' do
    expect(sequence(1, 2, 3).tail).to eq(sequence(2, 3))
  end

  it 'should lazily return tail' do
    expect(Sequence.new((1..Float::INFINITY).lazy).tail.head).to eq(2)
    expect(range(100).tail.head).to eq(101)
  end

  it 'should return empty tail on sequence with 1 item' do
    expect(sequence(1).tail).to eq(empty)
  end

  it 'should raise NoSuchElementException when getting a tail of empty' do
    expect { empty.tail }.to raise_error(NoSuchElementException)
  end

  it 'should support init' do
    expect(sequence(1, 2, 3).init).to eq(sequence(1, 2))
  end

  it 'should raise NoSuchElementException when getting init of an empty' do
    expect { empty.init }.to raise_error(NoSuchElementException)
  end

  it 'should support map' do
    expect(sequence(1, 2, 3).map(->(a) { a*2 })).to eq(sequence(2, 4, 6))
  end

  it 'should support fold (aka fold_left)' do
    expect(sequence(1, 2, 3).fold(0, sum)).to eq(6)
    expect(sequence(1, 2, 3).fold_left(0, sum)).to eq(6)
    expect(sequence('1', '2', '3').fold(0, join)).to eq('0123')
    expect(sequence('1', '2', '3').fold_left(0, join)).to eq('0123')
  end

  it 'should support reduce (aka reduce_left)' do
    expect(sequence(1, 2, 3).reduce(sum)).to eq(6)
    expect(sequence(1, 2, 3).reduce_left(sum)).to eq(6)
    expect(sequence('1', '2', '3').reduce(join)).to eq('123')
    expect(sequence('1', '2', '3').reduce_left(join)).to eq('123')
  end

  it 'should support fold_right' do
    expect(empty.fold_right(4, sum)).to eq(4)
    expect(sequence(1).fold_right(4, sum)).to eq(5)
    expect(sequence(1, 2).fold_right(4, sum)).to eq(7)
    expect(sequence(1, 2, 3).fold_right(4, sum)).to eq(10)
    expect(empty.fold_right('4', join)).to eq('4')
    expect(sequence('1').fold_right('4', join)).to eq('14')
    expect(sequence('1', '2').fold_right('4', join)).to eq('124')
    expect(sequence('1', '2', '3').fold_right('4', join)).to eq('1234')
  end

  it 'should support reduce_right' do
    # expect(sequence().reduce_right(sum)).to eq(0)   <-- need a monoid to do this
    expect(sequence(1).reduce_right(sum)).to eq(1)
    expect(sequence(1, 2).reduce_right(sum)).to eq(3)
    expect(sequence(1, 2, 3).reduce_right(sum)).to eq(6)
    # expect(sequence().reduce_right()).to eq('')    <-- need a monoid to do this
    expect(sequence('1').reduce_right(join)).to eq('1')
    expect(sequence('1', '2').reduce_right(join)).to eq('12')
    expect(sequence('1', '2', '3').reduce_right(join)).to eq('123')
  end

  it 'should support find' do
    expect(empty.find(even)).to eq(none)
    expect(sequence(1, 3, 5).find(even)).to eq(none)
    expect(sequence(1, 2, 3).find(even)).to eq(some(2))
  end

  it 'should support find_index_of' do
    expect(sequence(1, 3, 5).find_index_of(even)).to eq(none)
    expect(sequence(1, 3, 6).find_index_of(even)).to eq(some(2))
  end

  it 'should support zip_with_index' do
    expect(sequence('Dan', 'Kings', 'Raymond').zip_with_index).to eq(sequence(pair(0, 'Dan'), pair(1, 'Kings'), pair(2, 'Raymond')))
  end

  it 'should support zip' do
    sequence = sequence(1, 3, 5)
    expect(sequence.zip(sequence(2, 4, 6, 8))).to eq(sequence(pair(1, 2), pair(3, 4), pair(5, 6)))
    expect(sequence.zip(sequence(2, 4, 6))).to eq(sequence(pair(1, 2), pair(3, 4), pair(5, 6)))
    expect(sequence.zip(sequence(2, 4))).to eq(sequence(pair(1, 2), pair(3, 4)))
  end

  it 'should support take' do
    sequence = sequence(1,2,3).take(2)
    expect(sequence).to eq(sequence(1,2))
    expect(sequence(1).take(2)).to eq(sequence(1))
    expect(empty.take(2)).to eq(empty)
  end
end