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
    pf1.do_wave
    #pf1.trace_distmap
  end

  def test_wave_big
    map1 = Icfpc2012::Map.new(File.read('../maps/contest10.map.txt'))
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave
    #pf1.trace_distmap
  end

  def test_coords_to_actions
    coords = [
      [0, 0], [0, 1], [1, 1], [1, 0], [1, 0], [0, 0]
    ]

    path = Icfpc2012::CoordHelper.coords_to_actions coords

    assert(path == 'URDWL')
  end

  def test_coords_to_actions_invalid
    coords = [
      [0, 0], [1, 1]
    ]

    assert_raise(RuntimeError) do 
      Icfpc2012::CoordHelper.coords_to_actions coords
    end
  end
end