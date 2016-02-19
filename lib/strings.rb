module Strings
  def join(separator='')
    ->(a,b){"#{a}#{separator}#{b}"}
  end
end