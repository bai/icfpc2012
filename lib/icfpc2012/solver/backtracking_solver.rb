require 'set'

module Icfpc2012
  class BacktrackingSolver < LocalSolver
    attr_reader :best_solution # WaypointPath

    def initialize(map, region, target_cells, max_depth=-1)
      super(map, region, target_cells, max_depth)
      @best_solution = nil
      @cur_solution = WaypointPath.new(map)
      @want_lambdas = false
      @want_path = true
    end

    def solve()
      backtrack(Set.new)
      @best_solution
    end

    # Use to fix a stuck path.
    # @param map Last valid map state
    # @param target_path Array of desired path elements (coordinates)
    # param time_limit Time limit in milliseconds
    # @param priority 1 to 10, 10 being highest
    # @return a fixed path as a command list, nil if not found
    def self.repair_path(map, target_path, priority = 3)
      target_points = target_path.take(5) # simple heuristic
      region = Region.enclosing(target_points + [map.robot.position])
      BacktrackingSolver.new(map, region.expand(3 + priority/3), target_points, 3+priority).solve
    end

    private

    def heuristic(solution)
      (@want_lambdas ? solution.last_map.collected_lambdas * 100 : 0) +
        (@want_path ? -solution.waypoints.size * 100 : 0)
    end

    def backtrack(visited)
      #puts "entering: #{@cur_solution.path}"
      return  unless @cur_solution.valid?

      rob = @cur_solution.last_map.robot.position
      if in_target(rob) || @cur_solution.won?
        if !@best_solution || (@best_solution.current_value < @cur_solution.current_value)
          @best_solution = @cur_solution.deep_copy
        end
        return
      end

      return  if max_depth > 0 && visited.size > max_depth
      return  if @best_solution && (heuristic(@cur_solution) < heuristic(@best_solution))

      rocks_falling = @cur_solution.last_map.rockfall.falling_rocks.size > 0

      lambda_collected = @cur_solution.waypoints.size > 1 &&
          (@cur_solution.last_map.remaining_lambdas < @cur_solution.waypoints[-2].map.remaining_lambdas)

      if rocks_falling || (@want_lambdas && lambda_collected)
        visited = Set.new
      end

      #todo: heuristic: -no Lambdas- and the best solution's score cannot be reached

      points_around_point(rob).each do |next_position|
        move = CoordHelper::coords_to_action(rob, next_position)
        if !visited.include?(next_position) &&
            @region.in?(next_position) &&
            @cur_solution.last_map.can_go_to?(*next_position)
          if @cur_solution.add_move(move)
            backtrack(visited + [next_position])
          end
          @cur_solution.pop
        end
      end

      if @cur_solution.waypoints.last.movement != 'W' && rocks_falling
        if @cur_solution.add_move('W')
          backtrack(visited)
        end
        @cur_solution.pop
      end
    end

    def points_around cluster
      cluster.is_a?(Region) ?
          cluster.points_around :
          points_around_point(cluster)
    end

    def points_around_point(point)
      [
          [point[0], point[1]+1],
          [point[0], point[1]-1],
          [point[0]+1, point[1]],
          [point[0]-1, point[1]],
      ]
    end
  end
end