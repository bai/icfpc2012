module Icfpc2012
  # TODO: Optimize: don't keep all the Maps along the way, only keep some "keyframes" and re-evaluate the others.
  class WaypointPath
    attr_reader :waypoints

    def initialize(map, moves = '')
      @waypoints = [ Waypoint.new(nil, map) ]
      if moves != ''
        moves.each do |letter|
          if !@waypoints.last.map.robot.alive? || @waypoints.last.map.won?
            break
          end
          @waypoints << @waypoints.last.step(letter)
        end
      end
    end

    def valid?
      @waypoints.last.map.robot.alive?
    end

    def path
      @waypoints.map(&:movement).join
    end
  end
end