require_relative '../spec_helper'

describe 'Predicates' do
  it 'should allow regex matching' do
    expect(sequence('Stacy').find(matches?(/Stac/))).to eq(some('Stacy'))
    expect(sequence('Raymond').find(matches?(/NotAwesome/))).to eq(none)
  end

  it 'should allow is' do
    expect(sequence('Stuff').find(is?('Stuff'))).to eq(some('Stuff'))
    expect(sequence('Stuff').find(equal_to?('Stuff'))).to eq(some('Stuff'))
    expect(sequence('Stuff').find(is?('Nothing'))).to eq(none)
  end
end