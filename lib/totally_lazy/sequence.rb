require_relative 'lambda_block'

class NoSuchElementException < RuntimeError
end

class Array
  def to_seq
    Sequence.new(self.lazy)
  end
end

module Sequences
  def empty
    Sequence.empty
  end

  def sequence(*items)
    Sequence.sequence(*items)
  end

  def drop(sequence, count)
    Sequence.drop(sequence, count)
  end

  def sort(sequence, comparator=ascending)
    Sequence.sort(sequence, comparator)
  end

  def map_concurrently(sequence, fn=nil, &block)
    Sequence.map_concurrently(sequence, block_given? ? ->(value) { block.call(value) } : fn)
  end

  def group(key, enumerator)
    Group.new(key, enumerator)
  end

  def repeat(item)
    Sequence.new(repeat_enumerator(item))
  end

  def repeat_fn(item)
    Sequence.new(repeat_fn_enumerator(item))
  end

  private

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

class Sequence
  include Comparable
  include LambdaBlock

  attr_reader :enumerator

  def self.map_concurrently(sequence, fn=nil, &block)
    call_concurrently(sequence.map(defer_return(block_given? ? ->(value) { block.call(value) } : fn)))
  end

  def self.sort(sequence, comparator=ascending)
    Sequence.new(sequence.enumerator.sort { |a, b| comparator.(a, b) }.lazy)
  end

  def self.drop(sequence, count)
    Sequence.new(sequence.enumerator.drop(count))
  end

  def self.repeat(item)
    Sequence.new(repeat_enumerator(item))
  end

  def self.repeat_fn(item)
    Sequence.new(repeat_fn_enumerator(item))
  end

  def self.take(sequence, count)
    Sequence.new(sequence.enumerator.take(count))
  end

  def self.zip(left, right)
    left.zip(right)
  end

  def self.sequence(*items)
    if items.first.nil?
      empty
    else
      Sequence.new(items.lazy)
    end
  end

  def self.empty
    EMPTY
  end

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

  alias first head

  def second
    tail.head
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
    Sequence.new(reverse_enumerator(@enumerator))
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
    @enumerator.inject(seed) { |accumulator, value|
      block_given? ? block.call(accumulator, value) : fn.(accumulator, value)
    }
  end

  alias fold_left fold

  def fold_right(seed, fn=nil, &block)
    assert_funcs(fn, block_given?)
    reverse_enumerator(@enumerator).inject(seed) { |accumulator, value|
      block_given? ? block.call(value, accumulator) : fn.(value, accumulator)
    }
  end

  def reduce(fn=nil, &block)
    assert_funcs(fn, block_given?)
    _fn = block_given? ? ->(a, b) { block.call(a, b) } : fn
    accumulator = seed(@enumerator, fn)
    while has_next(@enumerator)
      accumulator = _fn.(accumulator, @enumerator.next)
    end
    accumulator
  end

  alias reduce_left reduce

  def reduce_right(fn=nil, &block)
    assert_funcs(fn, block_given?)
    _fn = block_given? ? ->(a, b) { block.call(a, b) } : fn
    reversed = reverse_enumerator(@enumerator)
    accumulator = seed(reversed, fn)
    while has_next(reversed)
      accumulator = _fn.(reversed.next, accumulator)
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
    Sequence.zip(range_from(0), self)
  end

  def find_index_of(fn_pred=nil, &block_pred)
    assert_funcs(fn_pred, block_given?)
    zip_with_index.find(->(pair) { block_given? ? block_pred.call(pair.second) : fn_pred.(pair.second) }).map(->(pair) { pair.first })
  end

  def take(count)
    Sequence.take(self, count)
  end

  def take_while(fn_pred=nil, &block_pred)
    assert_funcs(fn_pred, block_given?)
    Sequence.new(@enumerator.take_while { |value| block_given? ? block_pred.call(value) : fn_pred.(value) })
  end

  def drop(count)
    Sequence.drop(self, count)
  end

  def drop_while(fn_pred=nil, &block_pred)
    assert_funcs(fn_pred, block_given?)
    Sequence.new(@enumerator.drop_while { |value| block_given? ? block_pred.call(value) : fn_pred.(value) })
  end

  def flat_map(fn=nil, &block)
    assert_funcs(fn, block_given?)
    map(block_given? ? ->(value) { block.call(value) } : fn).flatten
  end

  def flatten
    Sequence.new(flatten_enumerator(enumerator))
  end

  def sort_by(comparator)
    Sequence.sort(self, comparator)
  end

  def contains?(value)
    @enumerator.member?(value)
  end

  def exists?(fn_pred=nil, &block_pred)
    assert_funcs(fn_pred, block_given?)
    @enumerator.any? { |value| block_given? ? block_pred.call(value) : fn_pred.(value) }
  end

  def for_all?(fn_pred=nil, &block_pred)
    assert_funcs(fn_pred, block_given?)
    @enumerator.all? { |value| block_given? ? block_pred.call(value) : fn_pred.(value) }
  end

  def filter(fn_pred=nil, &block_pred)
    assert_funcs(fn_pred, block_given?)
    Sequence.new(@enumerator.select { |value| block_given? ? block_pred.call(value) : fn_pred.(value) })
  end

  def reject(fn_pred=nil, &block_pred)
    assert_funcs(fn_pred, block_given?)
    filter(_not(block_given? ? ->(value) { block_pred.call(value) } : fn_pred))
  end

  def group_by(fn=nil, &block)
    assert_funcs(fn, block_given?)
    groups = @enumerator.group_by { |value| block_given? ? block.call(value) : fn.(value) }
    Sequence.new(groups.to_a.map { |group| Group.new(group[0], group[1].lazy) }.lazy)
  end

  def each(fn=nil, &block)
    assert_funcs(fn, block_given?)
    @enumerator.each { |value| block_given? ? block.call(value) : fn.(value) }
  end

  def map_concurrently(fn=nil, &block)
    assert_funcs(fn, block_given?)
    Sequence.map_concurrently(self, block_given? ? ->(value) { block.call(value) } : fn)
  end

  def realise
    Sequence.new(@enumerator.to_a.lazy)
  end

  def <=>(other)
    @enumerator.entries <=> other.enumerator.entries
  end

  def to_s
    "[#{self.take(100).reduce(join_with_sep(','))}]"
  end

  private
  def seed(enumerator, fn)
    enumerator.rewind
    !fn.nil? && fn.respond_to?(:identity) ? fn.identity : enumerator.next
  end
end

class Group < Sequence
  include Comparable
  attr_reader :key

  def initialize(key, enumerator)
    super(enumerator)
    @key = key
  end

  def <=>(other)
    (@key <=> other.key) <=> (enumerator.entries<=>(other.enumerator.entries))
  end
end

EMPTY=Sequence.new([].lazy)