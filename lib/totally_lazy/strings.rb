module Strings
  private
  def join(separator='')
    monoid(->(a, b) { "#{a}#{separator}#{b}" }, '')
  end

  def to_characters
    ->(string) { Sequence.new(character_enumerator(string)) }
  end

  def to_string
    ->(value) { value.to_s }
  end
end