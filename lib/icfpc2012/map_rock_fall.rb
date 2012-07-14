module Icfpc2012
  class MapRockFall
    def initialize(old_input, robot_position)
      @old_input = old_input
      @robot_position = robot_position
      @robot_dead = false
      @updated_input = update_map
    end

    # TODO: Implement a list of falling rocks
    def falling_rocks
      []
    end

    # TODO: Rename "input" so smth like "mapArray"
    def updated_input
      @updated_input
    end

    def alive?
      !@robot_dead
    end

    private

    def can_fall_to(x, y)
      @old_input[y][x] == Map::EMPTY
    end

    # Returns an updated input array
    def update_map()
      new_input = @old_input.map(&:dup)
      #new_input[@robot_position[1]][@robot_position[0]] = Map::EMPTY

      (0..@old_input[0].size-1).each do |x|
        (0..@old_input.size-1).each do |y|
          if (@old_input[y][x] == Map::ROCK) &&
              (@old_input[y-1][x] == Map::EMPTY)
            new_input[y][x] = Map::EMPTY
            new_input[y-1][x] = Map::ROCK
          end

          if (@old_input[y][x] == Map::ROCK) &&
              (@old_input[y-1][x] == Map::ROCK) &&
              (@old_input[y][x+1] == Map::EMPTY) &&
              (@old_input[y-1][x+1] == Map::EMPTY)
            new_input[y][x] = Map::EMPTY
            new_input[y-1][x+1] = Map::ROCK
          end

          if (@old_input[y][x] == Map::ROCK) &&
              (@old_input[y-1][x] == Map::ROCK) &&
              ((@old_input[y][x+1] != Map::EMPTY) || (@old_input[y-1][x+1] != Map::EMPTY)) &&
              (@old_input[y][x-1] == Map::EMPTY) &&
              (@old_input[y-1][x-1] == Map::EMPTY)
            new_input[y][x] = Map::EMPTY
            new_input[y-1][x-1] = Map::ROCK
          end

          if (@old_input[y][x] == Map::ROCK) &&
              (@old_input[y-1][x] == Map::LAMBDA) &&
              (@old_input[y][x+1] == Map::EMPTY) &&
              (@old_input[y-1][x+1] == Map::EMPTY)
            new_input[y][x] = Map::EMPTY
            new_input[y-1][x+1] = Map::ROCK
          end
        end
      end

      if new_input[@robot_position[1]][@robot_position[0]] == Map::ROCK
      #  new_input[@robot_position[1]][@robot_position[0]] == Map::ROBOT
      #else
        @robot_dead = true
      end
      new_input
    end
  end
end