module Pair

  def pair(first, second)
    Pair.new(first, second)
  end

  class Pair
    include Comparable

    def initialize(first, second)
      @first = -> { first }
      @second = -> { second }
    end

    def first
      @first.()
    end

    def second
      @second.()
    end

    def enumerator
      Enumerator.new { |y|
        y << first
        y << second
        raise StopIteration.new
      }
    end

    def <=>(other)
      (first <=> other.first) <=> (second <=> other.second)
    end

    def to_s
      "(#{first}, #{second})"
    end
  end

end