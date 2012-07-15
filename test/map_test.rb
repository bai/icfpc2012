require File.expand_path('../test_helper', __FILE__)

class MapTest < Test::Unit::TestCase
  def test_construct_simple

    assert_raise(RuntimeError) { Icfpc2012::Map.new("##L") }
    assert_raise(RuntimeError) { Icfpc2012::Map.new("##R") }

    map1 = Icfpc2012::Map.new("##RL")
    assert_equal(4, map1.width)
    assert_equal(1, map1.height)
    assert_equal(0, map1.score)
    assert_equal('#', map1.get_at(0, 0))

    map2_string = <<-'EOS'.gsub /^.*?-/, ''
      -#R###
      -#  \#
      -# * #
      -#-L##
    EOS

    map2 = Icfpc2012::Map.new(map2_string)

    assert_equal(5, map2.width)
    assert_equal(4, map2.height)

    assert_equal(1, map2.robot.x)
    assert_equal(3, map2.robot.y)

    assert_equal(1, map2.remaining_lambdas)
    assert_equal(0, map2.collected_lambdas)

    assert_equal('#', map2.get_at(0, 0))
    assert_equal('R', map2.get_at(1, 3), "map:\n" + map2.to_s)
    assert_equal('\\', map2.get_at(3, 2))

    assert_equal(2, map2.lift_x)
    assert_equal(0, map2.lift_y)

    assert !(map1 == map2), 'Maps should be equal'
  end

  def test_flooding
    map_string = <<EOS
#####
#R  #
#   #
##L##

Water 2
Flooding 11
Waterproof 5
EOS

    map = Icfpc2012::Map.new(map_string)
    assert_equal(2, map.water)
    assert_equal(11, map.flooding)
    assert_equal(5, map.waterproof)
    assert(!map.robot_underwater?)

    assert_equal(4, map.height)

    (1..10).each { |i|
      map = map.step('W')
      assert_equal(2, map.water, "Water is 2 on step #{i}")
    }
    map = map.step('W')
    assert_equal(3, map.water, "Water raises on step 11")
    assert(map.robot_underwater?)

    (1..5).each {
      map = map.step('W')
      assert(map.robot.alive?)
    }
    map = map.step('W')
    assert(!map.robot.alive?)
  end
end
