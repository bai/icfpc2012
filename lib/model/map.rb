require "rubygems"
require "bundler/setup"

class Map
  ROBOT_SYMBOL = 'R'

  attr_reader :width, :height, :score, :robot_dead, :remaining_lambdas, :collected_lambdas

  def initialize(input)
    @input = []
    input.each_line do |l|
      @input << l.chomp.split(//)
    end
    @input.reverse!

    @width  = @input.max_by(&:length).size
    @height = @input.length
    @score  = 0
    @robot_dead = false
    @collected_lambdas = 0
    @remaining_lambdas = input.count('\\')
  end

  # Map item at the given coordinates
  def get_at(x, y)
    if x >= width || x < 0 || y >= height || y < 0
      return '%'
    end

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
      move([robot_x, robot_y])
    when 'R'
      move([robot_x+1, robot_y])
    when 'L'
      move([robot_x-1, robot_y])
    when 'D'
      move([robot_x, robot_y-1])
    when 'U'
      move([robot_x, robot_y+1])
    when 'A'
      exit()
    else
      raise move.inspect
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
    @input.reverse.map(&:join).join("\n")
  end

  private

  def robot_position
    @robot_position ||= locate2d(@input, 'R').flatten
  end

  def lift_position
    @lift_position ||= locate2d(@input, 'L').flatten
  end

  def move(new_robot_position)

    new_map = self.dup
    new_map.instance_variable_set('@score', @score-1)
    new_input = @input.dup

    target_cell = get_at(*new_robot_position)
    if target_cell.match(/[ \.\\]/)

      new_map.instance_variable_set('@robot_position', new_robot_position)
      new_input[robot_y][robot_x] = ' '
      x = new_robot_position[0]
      y = new_robot_position[1]
      new_input[y][x] = 'R'

      if target_cell == '\\'
        new_map.instance_variable_set('@remaining_lambdas', @remaining_lambdas - 1)
        new_map.instance_variable_set('@collected_lambdas', @collected_lambdas + 1)
      end
    end

    #new_input = update_map(new_input)

    new_map.instance_variable_set('@input', new_input)
    new_map
  end

  # Returns an updated input array
  def update_map(old_input)
    new_input = old_input.dup

    (0..width-1).map do |x|
      (0..height-1).map do |y|
        if (old_input[y][x] == '*') &&
            (old_input[y-1][x] == ' ')
          new_input[y][x] = ' '
          new_input[y-1][x] = '*'
        end

        if (old_input[y][x] == '*') &&
            (old_input[y-1][x] == '*') &&
            (old_input[y][x+1] == ' ') &&
            (old_input[y-1][x+1] == ' ')
          new_input[y][x] = ' '
          new_input[y-1][x+1] = '*'
        end

        if (old_input[y][x] == '*') &&
            (old_input[y-1][x] == '*') &&
            ((old_input[y][x+1] != ' ') || (old_input[y-1][x+1] != ' ')) &&
            (old_input[y][x-1] == ' ') &&
            (old_input[y-1][x-1] == ' ')
          new_input[y][x] = ' '
          new_input[y-1][x-1] = '*'
        end

        if (old_input[y][x] == '*') &&
            (old_input[y-1][x] == '\\') &&
            (old_input[y][x+1] == ' ') &&
            (old_input[y-1][x+1] == ' ')
          new_input[y][x] = ' '
          new_input[y-1][x+1] = '*'
        end

        #if get_at(x, y) == 'L'
        #  new_input[y][x] = 'O'
        #end

      end
    end

    new_input
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
