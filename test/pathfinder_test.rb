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
    pf1.do_wave(map1.robot.position, Icfpc2012::PathFinder::MIND_ROCKS)
    assert_equal(pf1.get_shortest_dist_to([1, 1]), 1)
  end

  def get_mapfile(file)
    File.read(File.join(File.dirname(__FILE__), '../maps/', file))
  end
  
  def test_shortest_path
    map1 = Icfpc2012::Map.new(get_mapfile('contest6.map.txt'))
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave(map1.robot.position, Icfpc2012::PathFinder::MIND_ROCKS)
    #pf1.print_distmap
    assert_equal(pf1.trace_shortest_path_to(pf1.enum_closest_lambdas[10]).size,
                 pf1.get_shortest_dist_to(pf1.enum_closest_lambdas[10]) + 1)
  end

  def test_commands_path
    map1 = Icfpc2012::Map.new(get_mapfile('contest3.map.txt'))
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave(map1.robot.position, Icfpc2012::PathFinder::MIND_ROCKS)
    #pf1.print_distmap
    assert_equal("RRRDDDDDLLLLLD",
                 Icfpc2012::CoordHelper.coords_to_actions(pf1.trace_shortest_path_to(pf1.enum_closest_lambdas[3])))
  end

  def test_safe_path
    map1 = Icfpc2012::Map.new(get_mapfile('avoidrocks.map'))
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave(map1.robot.position, Icfpc2012::PathFinder::STAY_AWAY_FROM_ROCKS)
    #pf1.print_distmap
    assert_equal("RUUURURRRDDDD",
                 Icfpc2012::CoordHelper.coords_to_actions(pf1.trace_shortest_path_to(pf1.enum_closest_lambdas[0])))
  end

end
