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
    pf1.do_wave(map1.robot.position, false)
    assert_equal(pf1.get_shortest_dist_to([1, 1]), 1)
  end

  def test_shortest_path
    map1 = Icfpc2012::Map.new(File.read('../maps/contest6.map.txt'))
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave(map1.robot.position, false)
    #pf1.print_distmap
    assert_equal(pf1.trace_shortest_path_to(pf1.enum_closest_lambdas[10]).size,
                 pf1.get_shortest_dist_to(pf1.enum_closest_lambdas[10]) + 1)
  end

  def test_commands_path
    map1 = Icfpc2012::Map.new(File.read('../maps/contest3.map.txt'))
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave(map1.robot.position, false)
    pf1.print_distmap
    assert_equal("RRRDDDDDLLLLLD",
                 Icfpc2012::CoordHelper.coords_to_actions(pf1.trace_shortest_path_to(pf1.enum_closest_lambdas[3])))
  end
end