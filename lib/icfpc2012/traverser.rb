module Icfpc2012
  class Traverser
    def self.path_for map, points
      path = []
      points.each_index do |index| 
        if index == (points.length - 1)
          break
        end 

        start_point = points[index]
        puts start_point.inspect
        end_point = points[index + 1]
        puts end_point.inspect

        pathfinder = Icfpc2012::PathFinder.new map
        pathfinder.do_wave start_point

        path = path.concat (pathfinder.trace_shortest_path_to(end_point))
      end

      (points.length - 1).times do |index|
      end

      path
    end
  end
end