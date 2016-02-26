require_relative 'spec_helper'

describe 'Option' do
  it 'should support is_empty? & is_defined?' do
    expect(some(1).is_empty?).to eq(false)
    expect(some(1).is_defined?).to eq(true)
    expect(none.is_empty?).to eq(true)
    expect(none.is_defined?).to eq(false)
  end

  it 'should support contains?' do
    expect(option(1).contains?(1)).to eq(true)
    expect(option(1).contains?(2)).to eq(false)
    expect(none.contains?(2)).to eq(false)
  end

  it 'should support exists' do
    expect(option(1).exists?(greater_than(0))).to eq(true)
    expect(option(1).exists? { |a| a > 0 }).to eq(true)
    expect(option(1).exists?(greater_than(1))).to eq(false)
    expect(none.exists?(greater_than(0))).to eq(false)
  end

  it 'should support is alias' do
    expect(option(1).is?(greater_than(0))).to eq(true)
    expect(option(1).is? { |a| a > 0 }).to eq(true)
    expect(option(1).is?(greater_than(1))).to eq(false)
    expect(none.is?(greater_than(0))).to eq(false)
  end

  it 'should support fold (aka fold_left)' do
    expect(option(1).fold(1, add)).to eq(2)
    expect(option(1).fold_left(1, add)).to eq(2)
    expect(option(1).fold(1) { |a, b| a + b }).to eq(2)
    expect(some(1).fold(1, add)).to eq(2)
    expect(none.fold(1, add)).to eq(1)
  end

  it 'should raise exception if you try to use both lambda and block' do
    expect { some(1).exists?(->(a) { a == 1 }) { |b| b == 2 } }.to raise_error(RuntimeError)
    expect { none.exists?(->(a) { a == 1 }) { |b| b == 2 } }.to raise_error(RuntimeError)
    expect { some(1).is?(->(a) { a == 1 }) { |b| b == 2 } }.to raise_error(RuntimeError)
    expect { none.is?(->(a) { a == 1 }) { |b| b == 2 } }.to raise_error(RuntimeError)
    expect { some(1).fold(0, ->(a, b) { a+b }) { |a, b| a+b } }.to raise_error(RuntimeError)
    expect { none.fold(0, ->(a, b) { a+b }) { |a, b| a+b } }.to raise_error(RuntimeError)
    expect { some(1).fold_left(0, ->(a, b) { a+b }) { |a, b| a+b } }.to raise_error(RuntimeError)
    expect { none.fold_left(0, ->(a, b) { a+b }) { |a, b| a+b } }.to raise_error(RuntimeError)
  end

end
