module Predicates
  private
  def _not(pred)
    -> (bool) { !pred.(bool) }
  end
end