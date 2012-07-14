module Icfpc2012
  # A path element containing a sequence of Maps and Movements that lead from one to another.
  class Waypoint
    attr_accessor :movement, :map

    def initialize(movement, map)
      @movement = movement
      @map = map
    end

    def step(direction)
      Waypoint.new(direction, @map.step(direction))
    end
  end
end