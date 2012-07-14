class Array
  
  # Shuffles the array modifying its order.
  def shuffle
    sort_by { Kernel.rand }
  end
  
  # Returns a shuffled copy of the array.
  def shuffle!
    self.replace shuffle
  end
  
  # Yields given bloc using arrays items pair by pair.
  # e.g.
  # <code>
  # ["a","b","c","d"].each_pair do |first, second|
  #  puts second + " - " + second
  # end
  # </code>
  # will print:
  # b - a
  # c - d
  # 
  def each_pair
    num = self.size/2
    (0..num-1).collect do |index|
      yield self[index*2], self[(index*2)+1]
    end
  end
  
  # Splits the array into two parts first from position
  # 0 to "position" and second from position "position+1" to
  # last position.
  # Returns two new arrays.
  def separate(position)
   return self[0..position], self[position+1..-1]
  end
  
  # gga4r relies on this method from RoR
  # taken from http://apidock.com/rails/v3.2.3/Array/in_groups_of
  def in_groups_of(number, fill_with = nil)
    if fill_with == false
      collection = self
    else
      # size % number gives how many extra we have;
      # subtracting from number gives how many to add;
      # modulo number ensures we don't add group of just fill.
      padding = (number - size % number) % number
      collection = dup.concat([fill_with] * padding)
    end

    if block_given?
      collection.each_slice(number) { |slice| yield(slice) }
    else
      groups = []
      collection.each_slice(number) { |group| groups << group }
      groups
    end
  end
end