require_relative 'lambda_block'

module Eithers
  private
  def left(value)
    Either.left(value)
  end

  def right(value)
    Either.right(value)
  end
end

class Either
  include Comparable

  def self.left(value)
    Left.new(value)
  end

  def self.right(value)
    Right.new(value)
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

  def <=>(other)
    @value <=> other.left_value
  end
end

class Right < Either
  include LambdaBlock

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

  def <=>(other)
    @value <=> other.right_value
  end
end