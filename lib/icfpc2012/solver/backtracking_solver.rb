require 'set'

module Icfpc2012
  class BacktrackingSolver < LocalSolver
    attr_reader :best_solution # WaypointPath

    def initialize(map, region, target, max_depth=-1)
      super(map, region, target, max_depth)
      @best_solution = nil
      @cur_solution = WaypointPath.new(map)
      @want_lambdas = false
      @want_path = true
      @analyzer = Analyzer.new(@cur_solution)
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
      # if we add more pattern we can test more points in target_path
      # in order to advance futher using pattern
      if target_path.length > 0
        ps = Icfpc2012::PatternSolver2.new
        path = ps.solve(map, target_path[0])
        if path
          return WaypointPath.new(map, path)
        end
      end
      
      target_points = target_path.take(10) # simple heuristic
      region = Region.enclosing(target_points + [map.robot.position])
      BacktrackingSolver.new(map, region.expand(3 + priority/3), target_points, 3+priority).solve
    end

    private

    def backtrack(visited)
      #puts "entering: #{@cur_solution.path}"
      return  unless @cur_solution.valid?

      rob = @cur_solution.last_map.robot.position
      if @target.in_target?(rob) || @cur_solution.won?
        if !@best_solution || (@target.heuristic(@best_solution) < @target.heuristic(@cur_solution))
          @best_solution = @cur_solution.deep_copy
        end
        return
      end

      return  if max_depth > 0 && visited.size > max_depth
      return  if @best_solution && (@target.heuristic(@cur_solution) < @target.heuristic(@best_solution))
      # Rough heuristic

      return unless @target.can_do_better?(@best_solution, @cur_solution)

      if @analyzer.near_beard? && @cur_solution.last_map.razors > 0
        if @cur_solution.add_move('S')
          backtrack(visited)
        end
        @cur_solution.pop
        return
      end

      if @analyzer.rocks_falling? || (@want_lambdas && @analyzer.lambda_collected?)
        visited = Set.new
      end

      next_points = @analyzer.points_around(rob).sort_by { |x| @target.distance_to_target(x) }

      next_points.each do |next_position|
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

      if @cur_solution.waypoints.last.movement != 'W' && @analyzer.rocks_falling?
        if @cur_solution.add_move('W')
          backtrack(visited)
        end
        @cur_solution.pop
      end
    end
  end
end
