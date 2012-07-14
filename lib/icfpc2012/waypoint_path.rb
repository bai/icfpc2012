module Icfpc2012
  # TODO: Optimize: don't keep all the Maps along the way, only keep some "keyframes" and re-evaluate the others.
  class WaypointPath
    attr_reader :waypoints, :way_passed

    def initialize(map, moves = '')
      @waypoints = [ Waypoint.new(nil, map) ]
      @way_passed = true
      if moves != ''
        moves.each_char do |letter|
          if !@waypoints.last.map.robot.alive? || @waypoints.last.map.won?
            break
          end

          waypoint = @waypoints.last.step(letter)

          move_executed = (letter == 'W') || @waypoints.last.map.robot.position != waypoint.map.robot.position
          unless move_executed
            @way_passed = false
            break
          end

          @waypoints << waypoint
        end
      end
    end

    def valid?
      @waypoints.last.map.robot.alive? && @way_passed
    end

    def path
      @waypoints.map(&:movement).join
    end
  end
end