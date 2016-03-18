require_relative 'lambda_block'

class Proc
  def optional
    ->(value) {
      begin
        Option.option(self.(value))
      rescue
        Option.none
      end
    }
  end
end

module Options
  private
  def option(value)
    Option.option(value)
  end

  def some(value)
    Option.some(value)
  end

  def none
    Option.none
  end
end

class Option
  include Comparable

  def self.option(value)
    value.nil? ? none : some(value)
  end

  def self.some(value)
    Some.new(value)
  end

  def self.none
    NONE
  end

  def is_defined?
    !is_empty?
  end

  def is?(fn_pred=nil, &block_pred)
    assert_funcs(fn_pred, block_given?)
    exists?(block_given? ? ->(value) { block_pred.call(value) } : fn_pred)
  end

  def flatten
    flat_map(identity)
  end
end

class Some < Option
  include LambdaBlock

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def contains?(value)
    @value == value
  end

  def exists?(fn_pred=nil, &block_pred)
    assert_funcs(fn_pred, block_given?)
    block_given? ? block_pred.call(@value) : fn_pred.(@value)
  end

  def map(fn=nil, &block)
    assert_funcs(fn, block_given?)
    option(block_given? ? block.call(@value) : fn.(@value))
  end

  def flat_map(fn=nil, &block) # function should return an option
    assert_funcs(fn, block_given?)
    block_given? ? block.call(@value) : fn.(@value)
  end

  def fold(seed, fn=nil, &block)
    assert_funcs(fn, block_given?)
    block_given? ? block.call(seed, @value) : fn.(seed, @value)
  end

  alias fold_left fold

  def is_empty?
    false
  end

  def size
    1
  end

  def get
    @value
  end

  def get_or_else(value_or_fn=nil, &block)
    assert_funcs(value_or_fn, block_given?)
    get
  end

  alias or_else get_or_else

  def get_or_nil
    get
  end

  def get_or_raise(error)
    get
  end

  alias get_or_throw get_or_raise

  def to_either(left)
    right(value)
  end

  def enumerator
    Enumerator.new { |y|
      y << @value
      raise StopIteration.new
    }
  end

  def <=>(other)
    @value <=> other.value
  end

  def to_s
    "some(#{value})"
  end
end

class None < Option
  include LambdaBlock

  def is_empty?
    true
  end

  def contains?(value)
    false
  end

  def exists?(fn_pred=nil, &block_pred)
    assert_funcs(fn_pred, block_given?)
    false
  end

  def map(fn=nil, &block)
    assert_funcs(fn, block_given?)
    none
  end

  def flat_map(fn=nil, &block) # function should return an option
    assert_funcs(fn, block_given?)
    none
  end

  def fold(seed, fn=nil &block)
    assert_funcs(fn, block_given?)
    seed
  end

  alias fold_left fold

  def size
    0
  end

  def get
    raise NoSuchElementException.new
  end

  def get_or_else(value_or_fn=nil, &block)
    assert_funcs(value_or_fn, block_given?)
    if (value_or_fn.respond_to? :call) || block_given?
      block_given? ? block.call : value_or_fn.()
    else
      value_or_fn
    end
  end

  alias or_else get_or_else

  def get_or_nil
    nil
  end

  def get_or_raise(error)
    raise error
  end

  alias get_or_throw get_or_raise
  def enumerator
    Enumerator.new { |y|
      raise StopIteration.new
    }
  end

  def to_either(value)
    left(value)
  end

  def <=>(other)
    other == NONE
  end

  def to_s
    'none'
  end
end

NONE=None.new
