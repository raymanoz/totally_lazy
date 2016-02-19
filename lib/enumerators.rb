module Enumerators
  def reverse(e)
    e.reverse_each
  end

  def has_next(e)
    begin
      e.peek
      true
    rescue StopIteration
      false
    end
  end

  def enumerator(fn, init)
    Enumerator.new do |y|
      value = init
      y << value
      loop do
        value = fn.(value)
        y << value
      end
    end.lazy
  end

  def repeat_enumerator(value)
    Enumerators.repeat_fn_enumerator(returns(value))
  end

  def repeat_fn_enumerator(fn)
    Enumerator.new do |y|
      loop do
        y << fn.()
      end
    end.lazy
  end
end