module Option

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

  class Some < Option
    include Comparable
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def contains?(value)
      @value == value
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

    def contains?(_)
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