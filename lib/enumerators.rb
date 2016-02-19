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
end