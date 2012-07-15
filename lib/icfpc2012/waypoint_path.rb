module Icfpc2012
  # TODO: Optimize: don't keep all the Maps along the way, only keep some "keyframes" and re-evaluate the others.
  class WaypointPath
    attr_reader :way_passed

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
      last_map.robot.alive? && @way_passed
    end

    def won?
      last_map.won?
    end

    def path
      @waypoints.map(&:movement).join
    end

    def deep_copy
      clone = self.dup
      clone.waypoints = waypoints.dup
      clone
    end

    def add_move(move)
      raise INVALID_ERROR unless valid?
      raise WON_ERROR if won?

      waypoint = @waypoints.last.step(move)

      @way_passed = (move == 'W') || last_map.robot.position != waypoint.map.robot.position
      @waypoints << waypoint  if @way_passed
      @way_passed
    end

    # Removes last path item/broken state
    def pop
      # Hopefully impassable solution cannot be continued further
      @waypoints.pop  if @way_passed
      @way_passed = true
    end

    # TODO: Looks like too intimate work with Map internals. Move to Map?
    def current_value
      last_map.score
    end

    def current_value_with_added
      last_map.score
    end

    # Approximate value that can be achieved by collecting all reachable Lambdas
    # TODO: Improve using Pathfinder co count only reachable Lambdas
    def potential_value
      average_distance_to_collect = last_map.width # Heuristics are approximate, you know?
      last_map.remaining_lambdas * 50 - average_distance_to_collect
    end

    def waypoints
      @waypoints
    end

    def last_map
      @waypoints.last.map
    end

    protected

    def waypoints=(wp)
      @waypoints = wp
    end

  end
end