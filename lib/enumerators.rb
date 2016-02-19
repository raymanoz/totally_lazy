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
      loop do
        y << value
        value = fn
      end
    end
  end
end