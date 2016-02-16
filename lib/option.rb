module Options

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

    private
    def <=>(other)
      @value <=> other.value
    end
  end

  private
  class None

  end

  NONE=None.new
end