module Icfpc2012

  # A pile of auxiliary functions for AI-like algorithms
  class Analyzer
    def initialize(waypoint_path)
      @cur_solution = waypoint_path
    end

    def near_beard?
      points_around_point(map.robot.position).any? { |p| map.get_at(*p) == Map::BEARD }
    end

    def rocks_falling?
      map.rockfall.falling_rocks.size > 0
    end

    def lambda_collected?
      @cur_solution.waypoints.size > 1 &&
          (map.remaining_lambdas < @cur_solution.waypoints[-2].map.remaining_lambdas)
    end

    def points_around(cluster)
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

    private

    def map
      @cur_solution.last_map
    end

  end
end