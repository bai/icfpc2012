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
    TRAMPOLINES = ['A','B','C','D','E','F','G','H','I']
    TARGETS     = ['1','2','3','4','5','6','7','8','9']
    BEARD       = 'W'
    RAZOR       = '!'

    attr_reader :lift_position
    attr_accessor :map_array, :score, :remaining_lambdas, :collected_lambdas, :robot
    attr_accessor :water, :flooding, :waterproof, :timer
    attr_accessor :trampolines
    attr_accessor :beard_growth, :razors
    attr_accessor :rockfall

    def initialize(input)
      parse_map(input)

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
      when 'W', 'R', 'L', 'D', 'U', 'S'
        new_coordinates = @robot.step(direction)
        move(new_coordinates, direction)

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

    def self.walkable?(char)
      char.match(/[A-I! \.\\O]/)
    end

    def walkable?(x, y)
      Map::walkable?(get_at(x, y))
    end

    def jumpable?(x, y)
      get_at(x, y).match(/[A-I]/)
    end

    def pushable?(x, y)
      get_at(x, y) == ROCK && y == @robot.y && map_array[y][2 * x - @robot.x] == EMPTY
    end

    def can_go_to?(x, y)
      walkable?(x, y) || jumpable?(x, y) || pushable?(x, y)
    end

    def robot_underwater?(robot_y = @robot.y)
      robot_y < self.water
    end

    def move(new_position, action = nil)
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
        elsif jumpable?(x, y)
          new_position = trampolines[target_cell]
          new_input[y][x] = EMPTY
          new_input[new_position[1]][new_position[0]] = ROBOT
          trampolines.each do |src, dst|
            if dst == new_position
              x, y = locate(src)
              new_input[y][x] = EMPTY
              trampolines.delete(src)
            end
          end
        elsif target_cell == OPEN_LIFT
          new_map.score += new_map.collected_lambdas*50
        elsif target_cell == RAZOR
          new_map.razors += 1
        end
      elsif pushable?(x, y)

        new_input[@robot.y][@robot.x] = EMPTY
        new_input[y][x] = ROBOT
        new_input[y][2 * x - @robot.x] = ROCK
      elsif action && action == 'S' && razors > 0
        new_map.razors -= 1
        Icfpc2012.do_ab ([x, y]) do |razor_x, razor_y|
          if get_at(razor_x, razor_y) == BEARD
            new_input[razor_y][razor_x] = EMPTY
          end
        end
      else
        new_position = @robot.position
      end

      new_rockfall = MapRockFallFast.new(new_input, new_position, rockfall)
      new_map.rockfall = new_rockfall

      new_map.robot = Robot.new(new_position[0], new_position[1], new_rockfall.alive?)

      # Use old water level
      robot_underwater = robot_underwater?(new_position[1])
      robot_alive = new_rockfall.alive? &&
          (!robot_underwater || robot.underwater_ticks < self.waterproof)

      if new_map.flooding != 0 && (new_map.timer % new_map.flooding == 0)
        new_map.water = water+1
      end
      new_map.robot = Robot.new(new_position[0], new_position[1], robot_alive,
                                robot_underwater ? robot.underwater_ticks+1 : 0)

      updated_input = new_rockfall.updated_input
      if new_map.beard_growth != 0 && (new_map.timer % new_map.beard_growth == 0)
        updated_input.each_index do |b_row|
          updated_input[b_row].each_index do |b_col|
            if updated_input[b_row][b_col] == EMPTY
              Icfpc2012.do_ab ([b_col, b_row]) do |c, r|
                if (get_at(c, r) == BEARD) && (updated_input[r][c] == BEARD)# i.e. beard not deleted
                  updated_input[b_row][b_col] = BEARD
                  break
                end
              end
            end
          end
        end
      end

      # Win freezes the world
      new_map.map_array = new_map.won? ? new_input : updated_input
      new_map
    end

    def locate(element)
      map_array.each_with_index do |subarray, i|
        j = subarray.index(element)
        return j, i if j
      end
      nil
    end

    def parse_map(input)
      owner = self
      owner.water = 0
      owner.flooding = 0
      owner.waterproof = 0
      owner.map_array = Array.new
      owner.trampolines = Hash.new

      owner.beard_growth = 25
      owner.razors = 0

      input_data = input.split(/\r?\n\r?\n/)
      owner.map_array = input_data.shift.split(/\r?\n/).map { |l| l.split(//) }.reverse

      input_data.join.split(/\r?\n/).each do |line|
        if line.match('Water\s+(\d+)') {|m| owner.water = Integer(m[1])}
        elsif line.match('Flooding\s+(\d+)') {|m| owner.flooding = Integer(m[1])  }
        elsif line.match('Waterproof\s+(\d+)') {|m| owner.waterproof = Integer(m[1])}
        elsif line.match('Trampoline\s+([A-I])\s+targets\s([1-9])') {|m| owner.trampolines[m[1]]=m[2]}
        elsif line.match('Growth\s+(\d+)') {|m| owner.beard_growth = Integer(m[1])}
        elsif line.match('Razors\s+(\d+)') {|m| owner.razors = Integer(m[1])}
        else
          raise "Unknown input line : " + line.inspect
        end
      end
      owner.trampolines.each {|k, v| owner.trampolines[k] = locate(v)}
    end
  end
end
