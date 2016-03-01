module Predicates
  private
  def _not(pred)
    -> (bool) { !pred.(bool) }
  end

  def is_left?
    -> (either) { either.is_left? }
  end

  def is_right?
    -> (either) { either.is_right? }
  end

  def matches?(regex)
    ->(value) { !regex.match(value).nil? }
  end
end