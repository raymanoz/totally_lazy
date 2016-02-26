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
      block_given? ? block_pred.call(@value) : fn_pred.(value)
    end

    def map(fn)
      some(fn.(value))
    end

    def enumerator
      Enumerator.new { |y|
        y << @value
        raise StopIteration.new
      }
    end

    def is_empty?
      false
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
      false
    end

    def map(fn)
      none
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