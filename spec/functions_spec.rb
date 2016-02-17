require_relative 'spec_helper'

describe 'Functions' do
  it 'should be callable with a value' do
    expect(TimesTwo.apply(5)).to eq(10)
  end

  TimesTwo = function1(->(a){a*2})
end