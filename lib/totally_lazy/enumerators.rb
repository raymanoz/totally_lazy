module Enumerators
  private
  def reverse_enumerator(e)
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

  def enumerator_of(fn, init)
    Enumerator.new do |y|
      value = init
      y << value
      loop do
        value = fn.(value)
        y << value
      end
    end.lazy
  end

  def repeat_fn_enumerator(fn)
    Enumerator.new do |y|
      loop do
        y << fn.()
      end
    end.lazy
  end

  def repeat_enumerator(value)
    repeat_fn_enumerator(returns(value))
  end

  def character_enumerator(string)
    Enumerator.new do |y|
      index = 0
      loop do
        raise StopIteration.new unless index < string.size
        y << string[index]
        index = index + 1
      end
    end.lazy
  end

  def flatten_enumerator(enumerator)
    Enumerator.new do |y|
      current_enumerator = empty_enumerator

      loop do
        until has_next(current_enumerator)
          unless has_next(enumerator)
            current_enumerator = empty_enumerator
            break
          end
          current_enumerator = enumerator.next.enumerator
        end

        if has_next(current_enumerator)
          y << current_enumerator.next
        else
          raise StopIteration.new
        end
      end
    end.lazy
  end

  def empty_enumerator
    [].lazy
  end
end