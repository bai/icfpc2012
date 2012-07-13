class Map

  def initialize(input)
    @input = input.split("\n").map { |l| l.split(//) }
    @width = @input.max_by(&:length)
    @height = @input.length
    @score = 0
  end

  def map_equals(other_map)
    false
  end

  def step(move)
    self
  end

end