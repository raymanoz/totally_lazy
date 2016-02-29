require_relative 'lambda_block'

module Option
  include LambdaBlock

  def option(value)
    value.nil? ? none : some(value)
  end

  def some(value)
    Some.new(value)
  end

  def none
    NONE
  end

  class Option
    def is_defined?
      !is_empty?
    end
  end

  def is?(fn_pred=nil, &block_pred)
    assert_funcs(fn_pred, block_given?)
    exists?(block_given? ? ->(value) { block_pred.call(value) } : fn_pred)
  end

  def flatten
    flat_map(identity)
  end

  class Some < Option
    include Comparable
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
      "Some(#{value})"
    end
  end

  class None < Option
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

    def enumerator
      Enumerator.new { |y|
        raise StopIteration.new
      }
    end

    def to_s
      'None'
    end
  end

  NONE=None.new
end