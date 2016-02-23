module Functions
  def returns(value)
    -> { value }
  end

  def identity
    -> (a) { a }
  end
end