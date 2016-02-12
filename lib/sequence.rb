module Sequences

  def empty
    Empty
  end

  def sequence(*items)
    if items.first.nil?
      empty
    else
      Sequence.new(items)
    end
  end

  class Sequence
    def initialize(*items)
      @enumerator = items.each
    end
  end

  private

  Empty=Sequence.new
end