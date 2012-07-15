module Icfpc2012
  class Scheduler

    LIGHT_SEARCH_WIDTH = 3
    HEAVY_SEARCH_WIDTH = 6

    attr_accessor :map_origin, :best_solution, :best_score, :max_iterations

    def initialize(map)
      self.map_origin = map
      self.best_solution = ""
      self.best_score = 0
      self.max_iterations = LIGHT_SEARCH_WIDTH
    end

    def process_wave(pf, map, path_so_far, score_so_far, depth)
      #pf.print_distmap

      if(map.remaining_lambdas == 0)
        path = Icfpc2012::CoordHelper.coords_to_actions(pf.trace_shortest_path_to(map.lift_position))

        return if(path == 'E')

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
        end
      end

      # iterate thru
      #interation = 0
      lambdas = pf.enum_closest_lambdas
      lambdas.each { |l|

        path = Icfpc2012::CoordHelper.coords_to_actions(pf.trace_shortest_path_to(l))

        #next if(path == 'E')

        wp = Icfpc2012::WaypointPath.new(map, path)

        #puts l.inspect
        #puts path
        #puts wp.waypoints.last.map.score

        if(wp.valid?)
          recurse(wp.waypoints.last.map, path_so_far + path, wp.waypoints.last.map.score, depth + 1)
        end

        #interation+=1
        #break if interation > max_iterations
      }
    end

    def recurse(map, path_so_far, score_so_far, depth)

      if(score_so_far > self.best_score)
        self.best_score = score_so_far
        self.best_solution = path_so_far
        map.to_s.each_line { |line| puts line }
        puts [self.best_solution, self.best_score].inspect
      end

      pf = Icfpc2012::PathFinder.new(map)

      pf.max_lambdas = max_iterations
      pf.do_wave(map.robot.position, Icfpc2012::PathFinder::MIND_ROCKS)
      process_wave(pf, map, path_so_far, score_so_far, depth)

      pf.do_wave(map.robot.position, Icfpc2012::PathFinder::IGNORE_ROCKS)
      process_wave(pf, map, path_so_far, score_so_far, depth)

    end

    def solve

      self.max_iterations = LIGHT_SEARCH_WIDTH
      recurse(map_origin, "", 0, 0)

      # we got something dirty now: try deeper
      self.max_iterations = HEAVY_SEARCH_WIDTH
      recurse(map_origin, "", 0, 0)
      [best_solution, best_score]
    end
  end
end