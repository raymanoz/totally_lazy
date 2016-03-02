module Predicates
  private
  def _not(pred)
    -> (bool) { !pred.(bool) }
  end

  def is_left
    -> (either) { either.is_left? }
  end

  def is_right
    -> (either) { either.is_right? }
  end

  def matches(regex)
    ->(value) { !regex.match(value).nil? }
  end

  def equal_to?(that)
    ->(this) { this == that }
  end
  alias is equal_to?

  def where(fn, predicate)
    ->(value) { predicate.(fn.(value)) }
  end
end