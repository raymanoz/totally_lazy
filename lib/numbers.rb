module Numbers
  def sum
    monoid(->(a, b) { a + b }, 0)
  end

  def even
    remainder_is(2, 0)
  end

  def odd
    remainder_is(2, 1)
  end

  def remainder_is(divisor, remainder)
    ->(dividend) { remainder(dividend, divisor) == remainder }
  end

  def remainder(dividend, divisor)
    dividend % divisor
  end

  def range_from(start)
    Sequence.new(Enumerators::enumerator(increment, start))
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
end