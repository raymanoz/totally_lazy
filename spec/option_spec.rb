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

end
