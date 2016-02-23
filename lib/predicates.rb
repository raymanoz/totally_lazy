module Predicates
  def not(pred)
    -> (bool) { !pred.(bool) }
  end
end