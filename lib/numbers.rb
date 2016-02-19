module Numbers
  def sum
    ->(a, b) { a + b }
  end

  def even
    remainder_is(2, 0)
  end

  def remainder_is(divisor, remainder)
    ->(dividend) { remainder(dividend, divisor) == remainder }
  end

  def remainder(dividend, divisor)
    dividend % divisor
  end

  def range(start)
    Sequence.new(Enumerators::enumerator(increment, start))
  end

  def increment
    ->(number) { number + 1 }
  end
end