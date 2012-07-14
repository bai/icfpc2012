module Icfpc2012
  class Map
    ROBOT       = 'R'
    WALL        = 'W'
    ROCK        = '*'
    LAMBDA      = '\\'
    CLOSED_LIFT = 'L'
    OPEN_LIFT   = 'O'
    EARTH       = '.'
    EMPTY       = ' '

    attr_writer   :width, :height
    attr_accessor :input, :score, :remaining_lambdas, :collected_lambdas, :robot

    def initialize(input)
      self.input = input.split(/\r?\n/).map { |l| l.rstrip.split(//) }.reverse

      unless @lift_position = locate(CLOSED_LIFT) || locate(OPEN_LIFT)
        raise "Lift not found on map"
      end

      unless robot_position = locate(ROBOT)
        raise "Robot not found on map"
      end

      # Locate robot
      @robot = Robot.new(*robot_position)

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
    def step(direction)
      if !@robot.alive?
        raise 'IllegalStateException: Robot is dead, you can no longer move!'
      end

      case direction
      when 'W', 'R', 'L', 'D', 'U'
        new_coordinates = @robot.step(direction)
        #new_coordinates = walkable?(*new_coordinates) ? new_coordinates : robot.position
        move new_coordinates
      when 'A'
        exit
      else
        raise move.inspect
      end
    end

    def lift_x
      @lift_position[0]
    end

    def lift_y
      @lift_position[1]
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

    def won?
      remaining_lambdas == 0 && robot.position == @lift_position
    end

    def walkable?(x, y)
      get_at(x, y).match(/[ \.\\O]/)
    end

    def move(new_position)
      x = new_position[0]
      y = new_position[1]

      new_map = self.dup
      new_map.score = score - 1
      new_input = input.map(&:dup)

      target_cell = get_at(x, y)

      if walkable?(x, y)
        new_input[@robot.y][@robot.x] = EMPTY
        new_input[y][x] = ROBOT

        if target_cell == LAMBDA
          new_map.remaining_lambdas = remaining_lambdas - 1
          new_map.collected_lambdas = collected_lambdas + 1
          new_map.score+=25

          if new_map.remaining_lambdas == 0
            new_input[lift_y][lift_x] = OPEN_LIFT
          end
        end

        if target_cell == OPEN_LIFT
          new_map.score += new_map.collected_lambdas*50
        end
      elsif target_cell == ROCK && y == @robot.y &&
          new_input[y][2 * x - @robot.x] == EMPTY

        new_input[@robot.y][@robot.x] = EMPTY
        new_input[y][x] = ROBOT
        new_input[y][2 * x - @robot.x] = ROCK
      else
        new_position = @robot.position
      end

      rockfall = MapRockFall.new(new_input, new_position)

      new_map.robot = Robot.new(new_position[0], new_position[1], rockfall.alive?)

      new_map.input = rockfall.updated_input
      new_map
    end

    def locate(element)
      input.each_with_index do |subarray, i|
        j = subarray.index(element)
        return j, i if j
      end
      nil
    end
  end
end
