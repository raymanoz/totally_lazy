module Sequences

  def empty
    EMPTY
  end

  def sequence(*items)
    if items.first.nil?
      empty
    else
      Sequence.new(*items)
    end
  end

  class Sequence
    def initialize(*items)
      @enumeratable = items
    end

    def head
      enumerator.next
    end

    def head_option
      begin
        some(enumerator.peek)
      rescue
        none
      end
    end

    private
    def enumerator
      @enumeratable.each
    end
  end

  private

  EMPTY=Sequence.new
end