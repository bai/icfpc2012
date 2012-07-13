module Icfpc2012
  class Map
    ROBOT       = 'R'
    WALL        = 'W'
    ROCK        = '*'
    LAMBDA      = '\\'
    CLOSED_LIFT = 'L'
    EARTH       = '.'
    EMPTY       = ' '

    attr_writer   :width, :height
    attr_accessor :input, :score, :remaining_lambdas, :collected_lambdas

    def initialize(input)
      self.input = input.split(/\r?\n/).map { |l| l.strip.split(//) }.reverse

      self.score             = 0
      self.collected_lambdas = 0
      self.remaining_lambdas = input.count(LAMBDA)
    end

    # Map item at the given coordinates
    def get_at(x, y)
      if x >= width || x < 0 || y >= height || y < 0
        '%'
      else
        input[y][x]
      end
    end

    # Checks whether two maps are identical (including Robot coordinates)
    def ==(another_map)
      self.to_s == another_map.to_s
    end

    # Returns a new instance of the map after the given step
    def step(move)
      case move
      when 'W' then move([ robot_x, robot_y ])
      when 'R' then move([ robot_x+1, robot_y ])
      when 'L' then move([ robot_x-1, robot_y ])
      when 'D' then move([ robot_x, robot_y-1 ])
      when 'U' then move([ robot_x, robot_y+1 ])
      when 'A' then exit
      else          raise move.inspect
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
      input.reverse.map(&:join).join("\n")
    end

    def width
      @width ||= input.max_by(&:size).size
    end

    def height
      @height ||= input.size
    end

    private

    def robot_position
      locate(ROBOT)
    end

    def lift_position
      locate(CLOSED_LIFT)
    end

    def move(new_robot_position)
      x = new_robot_position[0]
      y = new_robot_position[1]

      new_map = self.dup
      new_map.score = score - 1
      new_input = input.map(&:dup)


      target_cell = get_at(x, y)

      puts new_robot_position

      robot_x, robot_y = robot_position
      if target_cell.match(/[ \.\\]/)
        new_input[robot_y][robot_x] = EMPTY
        new_input[y][x] = ROBOT

        if target_cell == LAMBDA
          new_map.remaining_lambdas = remaining_lambdas - 1
          new_map.collected_lambdas = collected_lambdas + 1
        end
      end

      new_input = update_map(new_input)

      new_map.input = new_input
      new_map
    end

    # Returns an updated input array
    def update_map(old_input)
      new_input = old_input.dup

      (0..width-1).map do |x|
        (0..height-1).map do |y|
          if (old_input[y][x] == ROCK) &&
              (old_input[y-1][x] == EMPTY)
            new_input[y][x] = EMPTY
            new_input[y-1][x] = ROCK
          end

          if (old_input[y][x] == ROCK) &&
              (old_input[y-1][x] == ROCK) &&
              (old_input[y][x+1] == EMPTY) &&
              (old_input[y-1][x+1] == EMPTY)
            new_input[y][x] = EMPTY
            new_input[y-1][x+1] = ROCK
          end

          if (old_input[y][x] == ROCK) &&
              (old_input[y-1][x] == ROCK) &&
              ((old_input[y][x+1] != EMPTY) || (old_input[y-1][x+1] != EMPTY)) &&
              (old_input[y][x-1] == EMPTY) &&
              (old_input[y-1][x-1] == EMPTY)
            new_input[y][x] = EMPTY
            new_input[y-1][x-1] = ROCK
          end

          if (old_input[y][x] == ROCK) &&
              (old_input[y-1][x] == LAMBDA) &&
              (old_input[y][x+1] == EMPTY) &&
              (old_input[y-1][x+1] == EMPTY)
            new_input[y][x] = EMPTY
            new_input[y-1][x+1] = ROCK
          end
        end
      end

      new_input
    end

    def locate(element)
      input.each_with_index do |subarray, i|
        j = subarray.index(element)
        return j, i if j
      end
    end
  end
end
