class Map
  ROBOT_SYMBOL = 'R'

  attr_reader :width, :height, :score

  def initialize(input)
    @input = []
    input.each_line do |l|
      @input << l.chomp.split(//)
    end

    @width  = @input.max_by(&:length).size
    @height = @input.length
    @score  = 0
  end

  # Map item at the given coordinates
  def get_at(x, y)
    @input[y][x]
  end

  # If the map, including Robot coordinates, is the same as given
  def map_equals(other_map)
    false
  end

  # Returns a new instance of the map after the given step
  def step(move)
    self
  end

  def robot_x
    robot_position[0]
  end

  def robot_y
    robot_position[1]
  end

  private

  def robot_position
    @robot_position ||= locate2d(@input, 'R').flatten
  end

  def locate2d(arr, test)
    r = []
    arr.each_index do |i|
      row, j0 = arr[i], 0
      while row.include? test
        if j = (row.index test)
          r << [i, j0 + j]
          j  += 1
          j0 += j
          row = row.drop j
        end
      end
    end
    r
  end
end
