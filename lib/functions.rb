module Functions
  def returns(value)
    -> { value }
  end

  def identity
    -> (a) { a }
  end

  def call_raises(e)
    -> { raise e }
  end

  def call
    ->(fn) { fn.() }
  end

  def flip(fn)
    ->(a,b) { fn.(b,a) }
  end
end