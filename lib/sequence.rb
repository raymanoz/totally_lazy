class NoSuchElementException < RuntimeError
end

module Sequences

  def empty
    EMPTY
  end

  def sequence(*items)
    if items.first.nil?
      empty
    else
      Sequence.new(items.lazy)
    end
  end

  class Sequence
    include Comparable
    attr_reader :enumerator

    def initialize(enumerator)
      @enumerator = enumerator
    end

    def head
      @enumerator.first
    end

    def head_option
      option(head)
    end

    def last
      reverse.head
    end

    def last_option
      reverse.head_option
    end

    def reverse
      Sequence.new(Enumerators::reverse(@enumerator))
    end

    def tail
      unless has_next(@enumerator)
        raise NoSuchElementException.new
      end
      Sequence.new(@enumerator.drop(1))
    end

    def init
      reverse.tail.reverse
    end

    def map(fn)
      Sequence.new(@enumerator.map{|a| fn.(a)})
    end

    def reduce_right(fn)
      reversed = Enumerators::reverse(@enumerator)
      accumulator = reversed.next
      while has_next(reversed)
        accumulator = fn.(reversed.next, accumulator)
      end
      accumulator
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
  end

  private

  EMPTY=Sequence.new([].each)
end