module Functions
  class Function1
    def initialize(fn)
      @fn = fn
    end

    def apply(value)
      @fn.(value)
    end
  end
end