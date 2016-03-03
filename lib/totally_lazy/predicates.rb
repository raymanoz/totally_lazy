module Predicates
  private
  def predicate(fn)
    def fn.and(other)
      -> (value) { self.(value) && other.(value) }
    end
    def fn.or(other)
      -> (value) { self.(value) || other.(value) }
    end
    fn
  end

  def is_not(pred)
    predicate(-> (bool) { !pred.(bool) })
  end

  def matches(regex)
    predicate(->(value) { !regex.match(value).nil? })
  end

  def equal_to?(that)
    predicate(->(this) { this == that })
  end
  alias is equal_to?

  def where(fn, predicate)
    predicate(->(value) { predicate.(fn.(value)) })
  end
end

class PredicateFunction < Proc
  def and(other)
    ->(value) { self.(value) && other.(value) }
  end

  def or(other)
    ->(value) { self.(value) || other.(value) }
  end
end