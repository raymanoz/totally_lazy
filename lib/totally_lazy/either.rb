require_relative 'lambda_block'

class Proc
  def or_exception
    -> (value) {
      begin
        right(self.(value))
      rescue Exception => e
        left(e)
      end
    }
  end
end

module Eithers
  private
  def left(value)
    Either.left(value)
  end

  def right(value)
    Either.right(value)
  end

  def as_left
    ->(value) { left(value) }
  end
  
  def as_right
    ->(value) { right(value) }
  end
end

class Either
  include Comparable
  include LambdaBlock

  def self.left(value)
    Left.new(value)
  end

  def self.right(value)
    Right.new(value)
  end

  def flatten
    flat_map(identity)
  end
end

class Left < Either
  def initialize(value)
    @value = value
  end

  def is_left?
    true
  end

  def is_right?
    false
  end

  def left_value
    @value
  end

  def right_value
    raise NoSuchElementException.new
  end

  def map_lr(fn_left, fn_right)
    fn_left.(@value)
  end

  def map_left(fn=nil, &block)
    assert_funcs(fn, block_given?)
    left(block_given? ? block.call(@value) : fn.(@value))
  end

  def flat_map(fn=nil, &block) # a function which returns an either
    assert_funcs(fn, block_given?)
    self
  end

  def fold(seed, fn_left, fn_right)
    fn_left.(seed, @value)
  end

  def <=>(other)
    @value <=> other.left_value
  end

  def to_s
    "left(#{@value})"
  end
end

class Right < Either
  def initialize(value)
    @value = value
  end

  def is_left?
    false
  end

  def is_right?
    true
  end

  def left_value
    raise NoSuchElementException.new
  end

  def right_value
    @value
  end

  def map(fn=nil, &block)
    assert_funcs(fn, block_given?)
    right(block_given? ? block.call(@value) : fn.(@value))
  end

  def map_lr(fn_left, fn_right)
    fn_right.(@value)
  end

  def map_left(fn=nil, &block)
    assert_funcs(fn, block_given?)
    self
  end

  def flat_map(fn=nil, &block) # a function which returns an either
    assert_funcs(fn, block_given?)
    block_given? ? block.call(@value) : fn.(@value)
  end

  def fold(seed, fn_left, fn_right)
    fn_right.(seed, @value)
  end

  def <=>(other)
    @value <=> other.right_value
  end

  def to_s
    "right(#{@value})"
  end
end