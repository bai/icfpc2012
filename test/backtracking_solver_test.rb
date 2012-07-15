require File.expand_path('../test_helper', __FILE__)

module Icfpc2012
  class BacktrackingSolverTest < Test::Unit::TestCase
    def test_simple
      map_string = <<-'EOS'.gsub /^.*?-/, ''
        -#R###
        -#  \#
        -# * #
        -##L##
      EOS

      map = Icfpc2012::Map.new(map_string)

      target_pos = [2, 0]
      solver = Icfpc2012::BacktrackingSolver.new(map, [0, 0, 8, 8], [target_pos], 25)
      path = solver.solve
      assert_equal(7, path.waypoints.size)
      assert_equal(target_pos, path.last_map.robot.position)
    end

    def dont_test_boulders
      map_string = <<-'EOS'.gsub /^.*?-/, ''
        -#\##L##
        -# **  #
        -R.*...#
        -##***.#
      EOS
      map = Icfpc2012::Map.new(map_string)

      target_pos = [4, 3]
      solver = Icfpc2012::BacktrackingSolver.new(map, [0, 0, 6, 6], [target_pos], 25)
      path = solver.solve
      assert_equal('RUUDRRRU', path.path)
    end

    def test_falling_locked
      map_string = <<-'EOS'.gsub /^.*?-/, ''
        - .****L
        -   *#..
        -  *R.*\
        - *.**.#
      EOS
      map = Icfpc2012::Map.new(map_string)

      target = [1,2]
      path = Icfpc2012::BacktrackingSolver::repair_path(map, [target])
      assert_equal('WLLU', path.path)
    end

    def test_well
      map_string = <<-'EOS'.gsub /^.*?-/, ''
        -#\#
        -#*#
        -# #
        -# #
        -# #
        -# L
        -R .
        -# #
      EOS
      map = Icfpc2012::Map.new(map_string)

      target = [1,6]
      path = Icfpc2012::BacktrackingSolver::repair_path(map, [target])
      assert_equal('RUDRWLUUUUU', path.path)
    end

    #def test_contest_10
    #    map_string = File.read("#{File.dirname(__FILE__)}/../maps/contest10.map.txt")
    #    map = Icfpc2012::Map.new(map_string)
    #
    #    #target = map.lift_position
    #    target = [0,23]
    #    path = Icfpc2012::BacktrackingSolver::repair_path(map, [target], 3)
    #    puts path
    #end

  end
end