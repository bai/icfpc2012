require "rubygems"
require "bundler/setup"

class Map
  ROBOT_SYMBOL = 'R'

  attr_reader :width, :height, :score, :robot_dead

  def initialize(input)
    @input = []
    input.each_line do |l|
      @input << l.chomp.split(//)
    end

    @width  = @input.max_by(&:length).size
    @height = @input.length
    @score  = 0
    @robot_dead = false
  end

  # Map item at the given coordinates
  def get_at(x, y)
    @input[y][x]
  end

  # If the map, including Robot coordinates, is the same as given
  def map_equals(other_map)
    self.to_s == other_map.to_s
  end

  # Returns a new instance of the map after the given step
  def step(move)
    case move
    when 'W'
      self
    when 'R'
      move([robot_x+1, robot_y])
    when 'L'
      move([robot_x-1, robot_y])
    when 'U'
      move([robot_x, robot_y-1])
    when 'D'
      move([robot_x, robot_y+1])
    else
      move([robot_x, robot_y])
    end
  end

  def robot_x
    robot_position[0]
  end

  def robot_y
    robot_position[1]
  end

  def robot_dead
    false
  end

  def lift_x
    lift_position[0]
  end

  def lift_y
    lift_position[1]
  end

  def to_s
    @input.map(&:join).join("\n")
  end

  private

  def robot_position
    @robot_position ||= locate2d(@input, 'R').flatten
  end

  def lift_position
    @lift_position ||= locate2d(@input, 'L').flatten
  end

  def move(new_robot_position)
    if new_robot_position[0] >= width || new_robot_position[0] < 0 ||
      new_robot_position[1] >= height || new_robot_position[1] < 0
      return self
    end

    target_cell = get_at(*new_robot_position)
    if target_cell.match(/[ .\\]/)
      new_map = self.dup
      new_map.instance_variable_set('@robot_position', new_robot_position)
      new_map.instance_variable_set('@score', @score-1)
      new_input = @input.dup
      new_input[robot_y][robot_x] = ' '
      x = new_robot_position[0]
      y = new_robot_position[1]
      new_input[y][x] = 'R'
      new_map.instance_variable_set('@input', new_input)
      return new_map
    end

    self
  end

  def locate2d(arr, test)
    r = []
    arr.each_index do |i|
      row, j0 = arr[i], 0
      while row.include? test
        if j = (row.index test)
          r << [j0 + j, i]
          j  += 1
          j0 += j
          row = row.drop j
        end
      end
    end
    r
  end
end
