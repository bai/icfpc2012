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
    attr_accessor :input, :score, :remaining_lambdas, :collected_lambdas, :path, :path_states

    def initialize(input)
      self.input = input.split(/\r?\n/).map { |l| l.strip.split(//) }.reverse

      self.score             = 0
      self.collected_lambdas = 0
      self.remaining_lambdas = input.count(LAMBDA)
      self.path              = ""
      self.path_states       = []
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
      self.path += move   
      case move
      when 'W' then move([ robot_x, robot_y ])
      when 'R' then move([ robot_x+1, robot_y ])
      when 'L' then move([ robot_x-1, robot_y ])
      when 'D' then move([ robot_x, robot_y-1 ])
      when 'U' then move([ robot_x, robot_y+1 ])
      when 'A' then
        exit
      else          raise move.inspect
      end
    end
    # Returns a new instance of the map before the last step
    def step_back()
      move_back
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
      res = locate(CLOSED_LIFT)
      if res == []
        res = locate(OPEN_LIFT)
      end
      puts "lisft: " + res.inspect
      res
    end

    def move(new_robot_position)
      x = new_robot_position[0]
      y = new_robot_position[1]

      new_map = self.dup
      new_map.score = score - 1
      new_input = input.map(&:dup)

      target_cell = get_at(x, y)
      robot_x, robot_y = robot_position

      path_state = [[robot_x, robot_y], target_cell, []]
      
      if target_cell.match(/[ \.\\O]/)
        new_input[robot_y][robot_x] = EMPTY
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
            new_map.score+=new_map.collected_lambdas*50
	    end
      elsif target_cell == ROCK && y == robot_y &&
          new_input[y][2 * x - robot_x] == EMPTY
        new_input[robot_y][robot_x] = EMPTY
        new_input[y][x] = ROBOT
        new_input[y][2 * x - robot_x] = ROCK
      end

      new_input = update_map(new_input, path_state[2])

      new_map.input = new_input
      new_map.path_states.push(path_state)
      #puts new_map.path_states.inspect
      new_map
    end

     def move_back()
      new_map = self.dup
      
      return new_map if new_map.path_states == []

      path_state = new_map.path_states.pop
      new_input = update_map_back(input.map(&:dup), path_state[2])

      robot_x, robot_y = robot_position
      old_x, old_y      = path_state[0]
      back_cell = path_state[1]

      new_map.path = path.chop
      new_map.score = score + 1
      if back_cell == OPEN_LIFT
          new_map.score-=new_map.collected_lambdas*50
      end
      
      if back_cell == LAMBDA        
        new_map.remaining_lambdas = remaining_lambdas + 1
        new_map.collected_lambdas = collected_lambdas - 1
        new_map.score-=25

        if new_map.remaining_lambdas != 0
          new_input[lift_y][lift_x] = CLOSED_LIFT
        end
      end
      
      if back_cell == ROCK
        new_input[robot_y][2 * robot_x - old_x] = EMPTY
      end
      new_input[robot_y][robot_x] = back_cell
      new_input[old_y][old_x] = ROBOT

      new_map.input = new_input
      new_map
    end

    # Returns an updated input array
    def update_map(old_input, update_state)
      new_input = old_input.map(&:dup)

      (0..width-1).map do |x|
        (0..height-1).map do |y|
          if (old_input[y][x] == ROCK) &&
              (old_input[y-1][x] == EMPTY)
            new_input[y][x] = EMPTY
            new_input[y-1][x] = ROCK
            update_state.push([0, x, y])
          end

          if (old_input[y][x] == ROCK) &&
              (old_input[y-1][x] == ROCK) &&
              (old_input[y][x+1] == EMPTY) &&
              (old_input[y-1][x+1] == EMPTY)
            new_input[y][x] = EMPTY
            new_input[y-1][x+1] = ROCK
            update_state.push([1, x, y])
          end

          if (old_input[y][x] == ROCK) &&
              (old_input[y-1][x] == ROCK) &&
              ((old_input[y][x+1] != EMPTY) || (old_input[y-1][x+1] != EMPTY)) &&
              (old_input[y][x-1] == EMPTY) &&
              (old_input[y-1][x-1] == EMPTY)
            new_input[y][x] = EMPTY
            new_input[y-1][x-1] = ROCK
            update_state.push([2, x, y])
          end

          if (old_input[y][x] == ROCK) &&
              (old_input[y-1][x] == LAMBDA) &&
              (old_input[y][x+1] == EMPTY) &&
              (old_input[y-1][x+1] == EMPTY)
            new_input[y][x] = EMPTY
            new_input[y-1][x+1] = ROCK
            update_state.push([3, x, y])
          end
        end
      end

      new_input
    end

    # Returns an old input array
    def update_map_back(old_input, update_state)
      new_input = old_input.map(&:dup)

      update_state.each do |old_update|
        rule, x, y = old_update
        
        new_input[y][x] = ROCK
        case rule
        when 0 then
            new_input[y-1][x] = EMPTY
        when 1 then
            new_input[y-1][x+1] = EMPTY
        when 2 then
            new_input[y-1][x-1] = EMPTY
        when 3 then
            new_input[y-1][x+1] = EMPTY
        else          raise old_update.inspect
        end
      end

      new_input
    end
    
    def locate(element)
      input.each_with_index do |subarray, i|
        j = subarray.index(element)
        return j, i if j
      end
      return []
    end
  end
end
