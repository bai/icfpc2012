require File.expand_path('../test_helper', __FILE__)

module Icfpc2012
  class BacktrackingSolverTest < Test::Unit::TestCase
    def test_simple
      map_string = <<EOS
#R###
#  \\#
# * #
##L##
EOS

      map = Icfpc2012::Map.new(map_string)

      target_pos = [2, 0]
      solver = Icfpc2012::BacktrackingSolver.new(map, [3, 3], 5, [target_pos], 25)
      path = solver.solve
      assert_equal(7, path.waypoints.size)
      assert_equal(target_pos, path.waypoints.last.map.robot.position)
    end

    def test_boulders
      map_string = <<EOS
#\\##L##
# **  #
#R*...#
##***.#
EOS

      map = Icfpc2012::Map.new(map_string)

      target_pos = [4, 3]
      solver = Icfpc2012::BacktrackingSolver.new(map, [3, 1], 10, [target_pos], 25)
      path = solver.solve
      assert_equal('UUDRRRU', path.path)
    end
  end
end