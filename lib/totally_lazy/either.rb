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

  def left
    @value
  end

  def right
    raise NoSuchElementException.new
  end

  def <=>(other)
    @value <=> other.left
  end
end

class Right < Either
  def initialize(value)
    @value = value
  end

  def is_left?
    false
  end

  def is_right?
    true
  end

  def left
    raise NoSuchElementException.new
  end

  def right
    @value
  end

  def <=>(other)
    @value <=> other.right
  end
end