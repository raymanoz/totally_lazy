require 'concurrent/executors'
require 'concurrent/promise'

class Proc
  def self.compose(f, g)
    lambda { |*args| f[g[*args]] }
  end

  def *(g)
    Proc.compose(self, g)
  end

  def and(g)
    Proc.compose(g, self)
  end
  alias and_then and
end

module Functions
  private
  def monoid(fn, id)
    fn.define_singleton_method(:identity) do
      id
    end
    fn
  end

  def returns(value)
    -> { value }
  end

  def ignore_and_return(value)
    returns1(value)
  end

  def returns1(value)
    constant(value)
  end

  def constant(value)
    ->(_) { value }
  end

  def identity
    -> (a) { a }
  end

  def call_raises(e)
    -> { raise e }
  end

  alias call_throws call_raises

  def call_fn
    ->(fn) { fn.() }
  end

  def flip(fn)
    ->(a, b) { fn.(b, a) }
  end

  def defer_return(fn)
    ->(value) { defer_apply(fn, value) }
  end

  def defer_apply(fn, value)
    ->() { fn.(value) }
  end

  def call_concurrently(sequence_of_fn)
    pool = Concurrent::CachedThreadPool.new
    begin
      call_concurrently_with_pool(sequence_of_fn, pool)
    ensure
      pool.shutdown
    end
  end

  def call_concurrently_with_pool(sequence_of_fn, pool)
    sequence_of_fn.
        map(as_promise).
        map(execute_with(pool)).
        realise.
        map(realise_promise)
  end

  def as_promise
    -> (fn) { Concurrent::Promise.new { fn.() } }
  end

  def execute_with(pool)
    -> (promise) {
      pool.post { promise.execute }
      promise
    }
  end

  def realise_promise
    ->(promise) { promise.value! }
  end

  def get_left
    ->(either) { either.left_value }
  end

  def get_right
    ->(either) { either.right_value }
  end
end