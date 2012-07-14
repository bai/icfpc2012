module Icfpc2012
  # TODO: Optimize: don't keep all the Maps along the way, only keep some "keyframes" and re-evaluate the others.
  class WaypointPath

    INVALID_ERROR       = "Can no longer move: already in invalid state"
    WON_ERROR           = "Can no longer move: you already won"

    attr_reader :waypoints, :way_passed

    def initialize(map, moves = '')
      @waypoints = [ Waypoint.new(nil, map) ]
      @way_passed = true

      begin
        if moves != ''
          moves.each_char do |letter|
            break unless add_move(letter)
            break if won?
          end
        end
      rescue RuntimeError
        # what to do here?
      end
    end

    def valid?
      @waypoints.last.map.robot.alive? && @way_passed
    end

    def won?
      @waypoints.last.map.won?
    end

    def path
      @waypoints.map(&:movement).join
    end

    def add_move(move)
      raise INVALID_ERROR unless valid?
      raise WON_ERROR if won?

      waypoint = @waypoints.last.step(move)

      move_executed = (move == 'W') || @waypoints.last.map.robot.position != waypoint.map.robot.position
      if move_executed
        @waypoints << waypoint
      else
        @way_passed = false
      end

      move_executed
    end
  end
end