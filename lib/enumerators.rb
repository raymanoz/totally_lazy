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
end