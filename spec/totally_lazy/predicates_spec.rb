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

  it 'should allow where' do
    raymond = Person.new('Raymond', 41)
    mathilda = Person.new('Mathilda', 4)
    age = ->(person) { person.age }
    expect(sequence(raymond, mathilda).filter(where(age, greater_than(40)))).to eq(sequence(raymond))
  end
end