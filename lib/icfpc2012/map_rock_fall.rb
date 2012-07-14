module Icfpc2012
  class MapRockFall
    def initialize(old_input, robot_position)
      @old_input = old_input
      @robot_position = robot_position
      @robot_dead = false
      update_map
    end

    # TODO: Implement a list of falling rocks
    def falling_rocks
      []
    end

    # TODO: Rename "input" so smth like "mapArray"
    def updated_input
      @new_input
    end

    def alive?
      !@robot_dead
    end

    private

    def fall_to(x, y)
      @new_input[y][x] = Map::ROCK

      if x == @robot_position[0] && y == @robot_position[1]+1
        @robot_dead = true
      end
    end

    # Returns an updated input array
    def update_map()
      @new_input = @old_input.map(&:dup)

      (0..@old_input[0].size-1).each do |x|
        (0..@old_input.size-1).each do |y|
          if (@old_input[y][x] == Map::ROCK) &&
              (@old_input[y-1][x] == Map::EMPTY)
            @new_input[y][x] = Map::EMPTY
            fall_to(x, y-1)
          end

          if (@old_input[y][x] == Map::ROCK) &&
              (@old_input[y-1][x] == Map::ROCK) &&
              (@old_input[y][x+1] == Map::EMPTY) &&
              (@old_input[y-1][x+1] == Map::EMPTY)
            @new_input[y][x] = Map::EMPTY
            fall_to(x+1, y-1)
          end

          if (@old_input[y][x] == Map::ROCK) &&
              (@old_input[y-1][x] == Map::ROCK) &&
              ((@old_input[y][x+1] != Map::EMPTY) || (@old_input[y-1][x+1] != Map::EMPTY)) &&
              (@old_input[y][x-1] == Map::EMPTY) &&
              (@old_input[y-1][x-1] == Map::EMPTY)
            @new_input[y][x] = Map::EMPTY
            fall_to(x-1, y-1)
          end

          if (@old_input[y][x] == Map::ROCK) &&
              (@old_input[y-1][x] == Map::LAMBDA) &&
              (@old_input[y][x+1] == Map::EMPTY) &&
              (@old_input[y-1][x+1] == Map::EMPTY)
            @new_input[y][x] = Map::EMPTY
            fall_to(x+1, y-1)
          end
        end
      end

      if @new_input[@robot_position[1]][@robot_position[0]] == Map::ROCK
        @robot_dead = true
      end
    end
  end
end