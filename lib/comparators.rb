module Comparators
  def ascending
    -> (a,b) { a <=> b }
  end

  def descending
    -> (a,b) { b <=> a }
  end
end