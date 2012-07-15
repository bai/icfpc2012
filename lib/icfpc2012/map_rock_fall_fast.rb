module Icfpc2012
  class MapRockFallFast
    def initialize(old_map_array, robot_position, prev_rock_fall = nil, beard_list = nil)
      @map_array = old_map_array
      @robot_position = robot_position
      @robot_dead = false
      @new_input = @map_array.dup
      @beard_list = beard_list
      @beard_list_new = Array.new


      if prev_rock_fall
        @active_places = update_places(prev_rock_fall.instance_variable_get('@active_places'))
      else
        @active_places = get_all_places
      end

      @falling_rocks = Array.new

      update_map
    end

    def falling_rocks
      @falling_rocks
    end

    # TODO: Rename "input" so smth like "mapArray"
    def updated_input
      @new_input
    end

    def beard_list
      @beard_list
    end

    def alive?
      !@robot_dead
    end

    # FIXME: Implement. Adds to the active list stones that robot could have touched.
    def check_movement(old_robot_position)

    end

    private

    def fall_to(x, y, xfall, yfall, apply_stone = true)
      if @new_input[y].object_id == @map_array[y].object_id
        @new_input[y] = @map_array[y].dup
      end
      if @new_input[yfall].object_id == @map_array[yfall].object_id
        @new_input[yfall] = @map_array[yfall].dup
      end

      @new_input[y][x] = Map::EMPTY

      if apply_stone && @new_input[yfall][xfall] != Map::ROCK
        @new_input[yfall][xfall] = Map::ROCK
        @falling_rocks.push([xfall, yfall])
      end

      if xfall == @robot_position[0] &&
          yfall == @robot_position[1]+1
        @robot_dead = true
      end
    end

    def set_beard(x, y)
      if @new_input[y][x] != Map::BEARD
        if @new_input[y].object_id == @map_array[y].object_id
          @new_input[y] = @map_array[y].dup
        end
        @new_input[y][x] = Map::BEARD
        @beard_list_new.push([x, y])
      end
    end

    def unset_beard(x, y)
      @beard_list_new.delete([x, y])
    end

    def is_value?(x, y, value)
      @map_array[y] && @map_array[y][x] == value
    end

    #returns all rocks places on map
    # FIXME: Брать не все камни, а не только те, которые будут падать.
    def get_all_places()
      places = Array.new

      @map_array.each_with_index do |row, y|
        row.each_with_index do |cell, x|
          places.push([x, y]) if cell == Map::ROCK
        end
      end

      places
    end

    def visited!(x, y, pos, visited, places)
      unless visited.has_key?(pos)
        places.push([x, y]) if is_value?(x, y, Map::ROCK)
        visited[pos] = 1
      end
    end

    #returns rocks places on map depending on last state
    def update_places(old_places)
      places = Array.new
      visited = Hash.new

      x,y = @robot_position
      (x-1..x+1).each do |xpos|
        (y-1..y+2).each do |ypos|
          new_pos = [xpos, ypos]
          visited!(xpos, ypos, new_pos, visited, places)
        end
      end

      old_places.each do |pos|
        x, y = pos
        (x-1..x+1).each do |xpos|
          (y-1..y+1).each do |ypos|
            new_pos = [xpos, ypos]
            visited!(xpos, ypos, new_pos, visited, places)
          end
        end
      end

      places
    end

    # Returns an updated input array
    def update_map()
      # grow beard
      if @beard_list
        @beard_list.each do |pos|
          Icfpc2012.do_ab (pos) do |beard_x, beard_y|
            if is_value?(beard_x, beard_y, Map::EMPTY)
              set_beard(beard_x, beard_y)
            end
          end
        end
      end

      @active_places.each do |pos|
        x, y = pos

        if is_value?(x, y-1, Map::EMPTY)
          apply_stone = ! is_value?(x+1, y, Map::BEARD)
          fall_to(x, y, x, y-1, apply_stone)
          unset_beard(x, y-1) if apply_stone
        end

        is_down_rock = is_value?(x, y-1, Map::ROCK)
        is_right_free = is_value?(x+1, y, Map::EMPTY) &&
                        is_value?(x+1, y-1, Map::EMPTY)

        if is_right_free
          if is_down_rock || is_value?(x, y-1, Map::LAMBDA)
            apply_stone = ! is_value?(x+2, y, Map::BEARD)
            fall_to(x, y, x+1, y-1, apply_stone)
            unset_beard(x+1, y-1) if apply_stone
          end
        elsif is_down_rock &&
              is_value?(x-1, y, Map::EMPTY) &&
              is_value?(x-1, y-1, Map::EMPTY)
            fall_to(x, y, x-1, y-1)
        end
      end

      # add grown beard
      @beard_list += @beard_list_new if @beard_list

      if @new_input[@robot_position[1]][@robot_position[0]] == Map::ROCK
        @robot_dead = true
      end
    end
  end
end