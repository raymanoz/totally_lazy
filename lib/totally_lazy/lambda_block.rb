module LambdaBlock
  private
  def assert_funcs(fn, block_given)
    raise 'Cannot pass both lambda and block expressions' if !fn.nil? && block_given
  end
end