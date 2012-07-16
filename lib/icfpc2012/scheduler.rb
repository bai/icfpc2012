module Icfpc2012
  class Scheduler

    LIGHT_SEARCH_WIDTH = 4
    HEAVY_SEARCH_WIDTH = 6

    attr_accessor :map_origin, :best_solution, :best_score, :max_iterations

    def initialize(map)
      self.map_origin = map
      self.best_solution = ""
      self.best_score = 0
      self.max_iterations = LIGHT_SEARCH_WIDTH
    end

    def process_wave(pf, map, path_so_far, score_so_far, depth, pfMind = nil)
=begin
      if(path_so_far.size != 0)

        wp0 = Icfpc2012::WaypointPath.new(map_origin, path_so_far)
        if(wp0.valid?)
          puts "failed process_wave validation at path:"
          puts wp0.path
          puts "with intended path:"
          puts path_so_far
          puts "last map:"
          wp0.last_map.to_s.each_line { |line| puts line }
          puts
          return
        end
      end
=end
      local_solver_priority = 2
      #pf.print_distmap

      if(map.remaining_lambdas == 0)
        path_coords = pf.trace_shortest_path_to(map.lift_position)
        path = Icfpc2012::CoordHelper.coords_to_actions(path_coords)

        #return if(path == 'E')

        wp = Icfpc2012::WaypointPath.new(map, path)
        #puts path
        #puts wp.waypoints.last.map.score

        if(wp.valid?)
          path_so_far += path
          score_so_far = wp.waypoints.last.map.score

          if(score_so_far > self.best_score)
            self.best_score = score_so_far
            self.best_solution = path_so_far
            wp.waypoints.last.map.to_s.each_line { |line| puts line }
            puts [self.best_solution, self.best_score].inspect
          end
        else

          path_remainder_coords = path_coords.last(path.size - wp.path.size)

          #puts "Solver called to solve path to exit:"
          #puts path_remainder_coords.inspect
          #wp.last_map.to_s.each_line { |line| puts line }

          solution = Icfpc2012::BacktrackingSolver.repair_path(wp.last_map, path_remainder_coords, local_solver_priority)
          #puts "Solver returned: "+(solution == nil ? "nil" : solution.path)

          if solution != nil
            #puts "exit solution found"
            recurse(solution.last_map, path_so_far + wp.path + solution.path, solution.last_map.score, depth + 1)
          end
        end

      end

      # iterate thru
      clusters = pf.enum_closest_clusters
      clusters.each { |cluster|
        l = cluster[0]
        path_coords = pf.trace_shortest_path_to(l)

        if(pfMind != nil)
          last_reachable_coord = path_coords.reverse.find { |coord|
            pfMind.get_shortest_dist_to(coord) != -1
            }

          if(last_reachable_coord == map.robot.position)

            path_coords_remainder = path_coords.last(path_coords.size - 1)
            #puts "Solver really needed and was called:"
            #puts path_coords_remainder.inspect
            #map.to_s.each_line { |line| puts line }

            solution = Icfpc2012::BacktrackingSolver.repair_path(map, path_coords_remainder, local_solver_priority)
            #puts "Solver returned: "+(solution == nil ? "nil" : solution.path)

            if solution != nil
              #puts "blocked solution found"
              recurse(solution.last_map, path_so_far + solution.path, solution.last_map.score, depth + 1)
            end
            return
          end

          path_coords = pfMind.trace_shortest_path_to(last_reachable_coord)

        end

        path = Icfpc2012::CoordHelper.coords_to_actions path_coords
        wp = Icfpc2012::WaypointPath.new(map, path)

        #puts l.inspect
        #puts path
        #puts wp.waypoints.last.map.score

        if(wp.valid?)
          recurse(wp.waypoints.last.map, path_so_far + path, wp.waypoints.last.map.score, depth + 1)
        else

          path_remainder_coords = path_coords.last(path.size - wp.path.size)

          #puts "Solver called to avoid rock:"
          #puts path_remainder_coords.inspect
          #wp.last_map.to_s.each_line { |line| puts line }

          solution = Icfpc2012::BacktrackingSolver.repair_path(wp.last_map, path_remainder_coords, local_solver_priority)
          #puts "Solver returned: "+(solution == nil ? "nil" : solution.path)

          if solution != nil
            #puts "died solution found"
            recurse(solution.last_map, path_so_far + wp.path + solution.path, solution.last_map.score, depth + 1)
          end
        end
      }
    end

    def recurse(map, path_so_far, score_so_far, depth)


        if(score_so_far > self.best_score)
          self.best_score = score_so_far
          self.best_solution = path_so_far
          map.to_s.each_line { |line| puts line }
          puts [self.best_solution, self.best_score].inspect
        end

        pfMindRocks = Icfpc2012::PathFinder.new(map)
        pfIgnoreRocks = Icfpc2012::PathFinder.new(map)

        pfMindRocks.max_clusters = max_iterations
        pfIgnoreRocks.max_clusters = max_iterations
        pfMindRocks.do_wave(map.robot.position, Icfpc2012::PathFinder::MIND_ROCKS)

        if(pfMindRocks.enum_closest_clusters.size != 0)
          process_wave(pfMindRocks, map, path_so_far, score_so_far, depth)
        else
          pfIgnoreRocks.do_wave(map.robot.position, Icfpc2012::PathFinder::IGNORE_ROCKS)
          process_wave(pfIgnoreRocks, map, path_so_far, score_so_far, depth, pfMindRocks)
        end
    end

    def solve

      begin # try catch for timing exception
        #timings
        Icfpc2012::Timer.new 150 # seconds
        self.max_iterations = LIGHT_SEARCH_WIDTH
        recurse(map_origin, "", 0, 0)

        # we got something dirty now: try deeper
        #self.max_iterations = HEAVY_SEARCH_WIDTH
        #recurse(map_origin, "", 0, 0, false)
        [best_solution, best_score]
      rescue RuntimeError
        [best_solution, best_score]
      ensure
        [best_solution, best_score]
      end
    end
  end
end