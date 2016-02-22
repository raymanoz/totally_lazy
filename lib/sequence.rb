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

  def take(sequence, count)
    Sequence.new(sequence.enumerator.take(count))
  end

  def repeat(item)
    Sequence.new(repeat_enumerator(item))
  end

  def repeat_fn(item)
    Sequence.new(repeat_fn_enumerator(item))
  end

  class Sequence
    include Comparable
    attr_reader :enumerator

    def initialize(enumerator)
      raise "Sequence only accepts Enumerator::Lazy, not #{enumerator.class}" unless (enumerator.class == Enumerator::Lazy)
      @enumerator = enumerator
    end

    def is_empty?
      @enumerator.rewind
      begin
        @enumerator.peek
        false
      rescue
        true
      end
    end

    def size
      @enumerator.count
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

    def map(fn=nil, &block)
      assert_funcs(fn, block_given?)
      Sequence.new(@enumerator.map { |value|
        block_given? ? block.call(value) : fn.(value)
      })
    end

    def fold(seed, fn=nil, &block)
      assert_funcs(fn, block_given?)
      accumulator = seed
      while has_next(@enumerator)
        accumulator = block_given? ? block.call(accumulator, @enumerator.next) : fn.(accumulator, @enumerator.next)
      end
      accumulator
    end

    alias fold_left fold

    def fold_right(seed, fn=nil, &block)
      assert_funcs(fn, block_given?)
      reversed = Enumerators::reverse(@enumerator)
      accumulator = seed
      while has_next(reversed)
        accumulator = block_given? ? block.call(reversed.next, accumulator) : fn.(reversed.next, accumulator)
      end
      accumulator
    end

    def reduce(fn=nil, &block)
      assert_funcs(fn, block_given?)
      fold_left(@enumerator.next, block_given? ? block : fn)
    end

    alias reduce_left reduce

    def reduce_right(fn=nil, &block)
      assert_funcs(fn, block_given?)
      reversed = Enumerators::reverse(@enumerator)
      accumulator = reversed.next
      while has_next(reversed)
        accumulator = block_given? ? block.call(reversed.next, accumulator) : fn.(reversed.next, accumulator)
      end
      accumulator
    end

    def find(fn_pred=nil, &block_pred)
      assert_funcs(fn_pred, block_given?)
      @enumerator.rewind
      while has_next(@enumerator)
        item = @enumerator.next
        result = block_given? ? block_pred.call(item) : fn_pred.(item)
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
      Sequences.zip(range_from(0), self)
    end

    def find_index_of(fn_pred=nil, &block_pred)
      assert_funcs(fn_pred, block_given?)
      zip_with_index.find(->(pair) { block_given? ? block_pred.call(pair.second) : fn_pred.(pair.second) }).map(->(pair) { pair.first })
    end

    def take(count)
      Sequences::take(self, count)
    end

    def take_while(fn_pred=nil, &block_pred)
      assert_funcs(fn_pred, block_given?)
      Sequence.new(enumerator.take_while{ |value| block_given? ? block_pred.call(value) : fn_pred.(value) })
    end

    def flat_map(fn=nil, &block)
      assert_funcs(fn, block_given?)
      map(block_given? ? ->(value) { block.call(value) } : fn).flatten
    end

    def flatten
      Sequence.new(flatten_enumerator(enumerator))
    end

    def <=>(other)
      @enumerator.entries <=> other.enumerator.entries
    end

    private
    def assert_funcs(fn, block_given)
      raise "Cannot pass both lambda and block expressions" if !fn.nil? && block_given
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