require File.expand_path('../test_helper', __FILE__)

class PathFinderTest < Test::Unit::TestCase
  def test_wave
    map1_string = <<EOS
####L
#*.\\#
# R #
#####
EOS
    map1 = Icfpc2012::Map.new(map1_string)
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave(map1.robot.position)
    assert_equal(pf1.get_shortest_dist_to([1, 1]), 1)
  end

  def test_shortest_path
    map1 = Icfpc2012::Map.new(File.read('../maps/contest6.map.txt'))
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave(map1.robot.position)
    #pf1.print_distmap
    assert_equal(pf1.trace_shortest_path_to(pf1.enum_closest_lambdas[10]).size,
                 pf1.get_shortest_dist_to(pf1.enum_closest_lambdas[10]) + 1)
  end

  def test_commands_path
    map1 = Icfpc2012::Map.new(File.read('../maps/contest3.map.txt'))
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave(map1.robot.position)
    #pf1.print_distmap
    assert_equal("RRRDDDDDLLLLLD",
                 Icfpc2012::CoordHelper.coords_to_actions(pf1.trace_shortest_path_to(pf1.enum_closest_lambdas[3])))
  end

  def test_path_invalid
    map1 = Icfpc2012::Map.new(File.read('../maps/contest9.map.txt'))
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave(map1.robot.position, Icfpc2012::PathFinder::IGNORE_ROCKS)
    #pf1.print_distmap

    path = Icfpc2012::CoordHelper.coords_to_actions(pf1.trace_shortest_path_to([3, 10]))
    wp = Icfpc2012::WaypointPath.new(map1, path)
    assert_equal(false, wp.valid?)
  end

  def test_path_valid
    map1 = Icfpc2012::Map.new(File.read('../maps/contest9.map.txt'))
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave(map1.robot.position, Icfpc2012::PathFinder::IGNORE_ROCKS)
    #pf1.print_distmap

    path = Icfpc2012::CoordHelper.coords_to_actions(pf1.trace_shortest_path_to([1, 1]))
    wp = Icfpc2012::WaypointPath.new(map1, path)
    assert_equal(true, wp.valid?)
  end
end