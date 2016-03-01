module Maps
  private
  def merge(sequence_of_maps)
    sequence_of_maps.fold({}){|a,b| a.merge(b) }
  end
end