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

  def zip(left, right)
    left.zip(right)
  end

  class Sequence
    include Comparable
    attr_reader :enumerator

    def initialize(enumerator)
      raise "Sequence only accepts Enumerator::Lazy, not #{enumerator.class}" unless (enumerator.class == Enumerator::Lazy)
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
      Sequence.new(@enumerator.map { |a| fn.(a) })
    end

    def fold(seed, fn)
      accumulator = seed
      while has_next(@enumerator)
        accumulator = fn.(accumulator, @enumerator.next)
      end
      accumulator
    end

    alias fold_left fold

    def fold_right(seed, fn)
      reversed = Enumerators::reverse(@enumerator)
      accumulator = seed
      while has_next(reversed)
        accumulator = fn.(reversed.next, accumulator)
      end
      accumulator
    end

    def reduce(fn)
      fold_left(@enumerator.next, fn)
    end

    alias reduce_left reduce

    def reduce_right(fn)
      reversed = Enumerators::reverse(@enumerator)
      accumulator = reversed.next
      while has_next(reversed)
        accumulator = fn.(reversed.next, accumulator)
      end
      accumulator
    end

    def find(predicate)
      @enumerator.rewind
      while has_next(@enumerator)
        item = @enumerator.next
        result = predicate.(item)
        if result
          return(some(item))
        end
      end
      none
    end

    def zip(other)
      Sequence.new(pair_enumerator(@enumerator, other.enumerator))
    end

    def zip_with_index
      Sequences.zip(range(0), self)
    end

    def find_index_of(predicate)
      @enumerator
      zip_with_index.find(->(pair) { predicate.(pair.second) }).map(->(pair) { pair.first })
    end

    def <=>(other)
      @enumerator.entries <=> other.enumerator.entries
    end
  end

  private

  EMPTY=Sequence.new([].lazy)

  def pair_enumerator(left, right)
    Enumerator.new do |y|
      left.rewind
      right.rewind
      loop do
        y << pair(left.next, right.next)
      end
    end.lazy
  end
end