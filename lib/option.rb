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

  class Some
    include Comparable
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def map(fn)
      some(fn.(value))
    end

    def <=>(other)
      @value <=> other.value
    end

    def to_s
      "Some(#{value})"
    end
  end

  private
  class None
    def map(fn)
      none
    end

    def to_s
      'None'
    end
  end

  NONE=None.new
end