require_relative '../spec_helper'

describe 'Predicates' do
  it 'should allow regex matching' do
    expect(sequence('Stacy').find(matches(/Stac/))).to eq(some('Stacy'))
    expect(sequence('Raymond').find(matches(/NotAwesome/))).to eq(none)
  end

  it 'should allow is' do
    expect(sequence('Stuff').find(is('Stuff'))).to eq(some('Stuff'))
    expect(sequence('Stuff').find(equal_to?('Stuff'))).to eq(some('Stuff'))
    expect(sequence('Stuff').find(is('Nothing'))).to eq(none)
  end

  class Person
    attr_reader :name
    attr_reader :age

    def initialize(name, age)
      @name = name
      @age = age
    end
  end
  raymond = Person.new('Raymond', 41)
  mathilda = Person.new('Mathilda', 4)
  age = ->(person) { person.age }

  it 'should allow where' do
    expect(sequence(raymond, mathilda).filter(where(age, greater_than(40)))).to eq(sequence(raymond))
  end

  it 'should be able to negate other predicates using is_not' do
    expect(sequence(raymond).filter(where(age, is_not(greater_than(40))))).to eq(empty)
  end

  it 'should allow predicates to be composed using logical operations (AND/OR)' do
    expect(sequence(1,2,3,4,5).filter(greater_than(2).and(odd))).to eq(sequence(3,5))
    expect(sequence(1,2,3,4,5).filter(greater_than(2).or(odd))).to eq(sequence(1,3,4,5))
  end
end