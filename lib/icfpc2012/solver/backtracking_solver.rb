require 'set'

module Icfpc2012
  class BacktrackingSolver < LocalSolver
    attr_reader :best_solution # WaypointPath

    def initialize(map, region_center, region_radius, target_cells, max_depth=-1)
      super(map, region_center, region_radius, target_cells, max_depth)
      @best_solution = nil
      @cur_solution = WaypointPath.new(map)
    end

    def solve()
      backtrack(Set.new)
      @best_solution
    end

    private

    def backtrack(visited)
      #puts "entering: #{@cur_solution.path}"

      return  unless @cur_solution.valid?

      r = @cur_solution.waypoints.last.map.robot.position
      if in_target(r)
        if !@best_solution || (@best_solution.current_value < @cur_solution.current_value)
          @best_solution = @cur_solution.deep_copy
          #puts "better: #{@cur_solution.path}"
        end
        return
      end

      return  if max_depth > 0 && visited.size > max_depth

      #FIXME: implement!
      lambda_collected = @cur_solution.waypoints.size > 1 &&
          (@cur_solution.waypoints.last.map.remaining_lambdas < @cur_solution.waypoints[-2].map.remaining_lambdas)
      rocks_moved = false

      if lambda_collected || rocks_moved
        visited = Set.new
      end

      #todo: heuristic: -no Lambdas- and the best solution's score cannot be reached

      'UDRL'.each_char { |move|
        next_position = CoordHelper::action_to_coords(r, move)
        if !visited.include?(next_position) &&
            in_region(next_position) &&
            @cur_solution.waypoints.last.map.can_go_to?(*next_position)
          if @cur_solution.add_move(move)
            backtrack(visited + [next_position])
          end
          @cur_solution.pop
        end
      }

    end

    # FIXME: Try W when there are boulders falling.
  end
end