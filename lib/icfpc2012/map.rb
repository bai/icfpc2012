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

    attr_accessor :map_array, :score, :remaining_lambdas, :collected_lambdas, :robot
    attr_accessor :water, :flooding, :waterproof, :timer, :rockfall

    def initialize(input)
      input = parse_water(input)
      self.map_array = input.split(/\r?\n/).map { |l| l.split(//) }.reverse

      unless (@lift_position = locate(CLOSED_LIFT) || locate(OPEN_LIFT))
        raise "Lift not found on map"
      end

      unless (robot_position = locate(ROBOT))
        raise "Robot not found on map"
      end

      # Locate robot
      @robot = Robot.new(*robot_position)

      self.score             = 0
      self.collected_lambdas = 0
      self.remaining_lambdas = input.count(LAMBDA)
      self.rockfall = nil
      self.timer = 0
    end

    # Map item at the given coordinates
    def get_at(x, y)
      if x >= width || x < 0 || y >= height || y < 0
        '%'
      else
        map_array[y][x]
      end
    end

    # Checks whether two maps are identical (including Robot coordinates)
    def ==(another_map)
      self.to_s == another_map.to_s
    end

    # Returns a new instance of the map after the given step
    def step(direction)
      unless @robot.alive?
        raise 'IllegalStateException: Robot is dead, you can no longer move!'
      end

      case direction
      when 'W', 'R', 'L', 'D', 'U'
        new_coordinates = @robot.step(direction)
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
      map_array.reverse.map(&:join).join("\n")
    end

    def width
      @width ||= map_array.max_by(&:size).size
    end

    def height
      @height ||= map_array.size
    end

    def won?
      remaining_lambdas == 0 && robot.position == @lift_position
    end

    def walkable?(x, y)
      get_at(x, y).match(/[ \.\\O]/)
    end

    def robot_underwater?(robot_y = @robot.y)
      robot_y < self.water
    end

    def move(new_position)
      x = new_position[0]
      y = new_position[1]

      new_map = self.dup
      new_map.score = score - 1
      new_map.timer = timer+1
      new_input = map_array.map(&:dup)

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

      new_rockfall = MapRockFallFast.new(new_input, new_position, rockfall)
      new_map.rockfall = new_rockfall

      new_map.robot = Robot.new(new_position[0], new_position[1], new_rockfall.alive?)

      # Use old water level
      robot_underwater = robot_underwater?(new_position[1])
      robot_alive = rockfall.alive? &&
          (!robot_underwater || robot.underwater_ticks < self.waterproof)

      new_map.input = new_rockfall.updated_input

      if new_map.flooding != 0 && (new_map.timer % new_map.flooding == 0)
        new_map.water = water+1
      end

      new_map.robot = Robot.new(new_position[0], new_position[1], robot_alive,
                                robot_underwater ? robot.underwater_ticks+1 : 0)

      # Win freezes the world
      new_map.map_array = new_map.won? ? new_input : rockfall.updated_input
      new_map
    end

    def locate(element)
      map_array.each_with_index do |subarray, i|
        j = subarray.index(element)
        return j, i if j
      end
      nil
    end

    def parse_water(input)
      chopped_input = input
      owner = self
      owner.water = 0
      owner.flooding = 0
      owner.waterproof = 0

      input.gsub(/(.*)\r?\nWater (\d+).*Flooding (\d+).*Waterproof (\d+)/m) {
        chopped_input = $1
        owner.water = Integer($2)
        owner.flooding = Integer($3)
        owner.waterproof = Integer($4)
        return chopped_input
      }
      chopped_input
    end
  end
end
