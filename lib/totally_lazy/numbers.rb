module Numbers
  private
  def sum
    monoid(->(a, b) { a + b }, 0)
  end

  def add(increment)
    -> (number) { number + increment }
  end

  def even
    remainder_is(2, 0)
  end

  def odd
    remainder_is(2, 1)
  end

  def divide(divisor)
    ->(dividend) { dividend / divisor }
  end

  def remainder_is(divisor, remainder)
    predicate(->(dividend) { remainder(dividend, divisor) == remainder })
  end

  def remainder(dividend, divisor)
    dividend % divisor
  end

  def range_from(start)
    Sequence.new(enumerator_of(increment, start))
  end

  def range(from, to)
    Sequence.new((from..to).lazy)
  end

  def increment
    ->(number) { number + 1 }
  end

  def mod(divisor)
    ->(number) { number % divisor }
  end

  def greater_than(right)
    predicate(->(left) { left > right })
  end
end