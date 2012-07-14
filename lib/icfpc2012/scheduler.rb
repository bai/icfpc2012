module Icfpc2012
  class Scheduler
    attr_accessor :map, :solution

    def initialize(map)
      self.map = map
      self.solution = ""
    end

    def solve
      pf1 = Icfpc2012::PathFinder.new(map1)
      pf1.do_wave(map1.robot.position, Icfpc2012::PathFinder::STAY_AWAY_FROM_ROCKS)
    end
  end
end