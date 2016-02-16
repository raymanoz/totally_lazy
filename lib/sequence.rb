module Sequences

  def empty
    EMPTY
  end

  def sequence(*items)
    if items.first.nil?
      empty
    else
      Sequence.new(items)
    end
  end

  class Sequence
    include Comparable

    def initialize(enumeratable)
      @enumeratable = enumeratable
    end

    def head
      enumerator.next
    end

    def head_option
      begin
        some(head)
      rescue StopIteration
        none
      end
    end

    def last
      reverse.head
    end

    def last_option
      reverse.head_option
    end

    def reverse
      sequence(*@enumeratable.reverse)
    end

    def enumerator
      @enumeratable.each
    end

    private
    def <=>(other)
      a_enumerator = enumerator
      b_enumerator = other.enumerator

      compare = 0
      while has_next(a_enumerator) && has_next(b_enumerator)
        a = a_enumerator.next
        b = b_enumerator.next
        compare = a<=>(b)
        if compare != 0
          return compare
        end
      end

      if !(has_next(a_enumerator) || has_next(b_enumerator))
        compare
      else
        has_next(a_enumerator) ? 1 : -1
      end
    end

    def has_next(enumerator)
      begin
        enumerator.peek
        true
      rescue StopIteration
        false
      end
    end
  end

  private

  EMPTY=Sequence.new([])
end