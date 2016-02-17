module Functions

  def function1(fn)
    Function1.new(fn)
  end

  class Function1
    def initialize(fn)
      @fn = fn
    end

    def apply(value)
      @fn.(value)
    end
  end
end