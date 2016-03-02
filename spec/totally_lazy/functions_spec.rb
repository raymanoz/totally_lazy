require_relative '../spec_helper'

describe 'Functions' do
  it 'should allow function composition and method chaining' do
    add_2 = ->(value) { value+2 }
    divide_by_2 = ->(value) { value/2 }
    expect(sequence(10).map(divide_by_2 * add_2)).to eq(sequence(6))
    expect(sequence(10).map(divide_by_2.and(add_2))).to eq(sequence(7))
  end
end
