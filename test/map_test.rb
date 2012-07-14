require File.expand_path('../test_helper', __FILE__)

class MapTest < Test::Unit::TestCase
  def test_construct_simple
    map1 = Icfpc2012::Map.new("##")
    assert_equal(2, map1.width)
    assert_equal(1, map1.height)
    assert_equal(0, map1.score)
    assert_equal('#', map1.get_at(0, 0))

    # TODO: Assert that we fail if no robot or lift found

    map2_string = <<EOS
#R###
#  \\#
# * #
#-L##
EOS

    map2 = Icfpc2012::Map.new(map2_string)

    assert_equal(5, map2.width)
    assert_equal(4, map2.height)

    assert_equal(1, map2.robot_x)
    assert_equal(3, map2.robot_y)

    assert_equal(1, map2.remaining_lambdas)
    assert_equal(0, map2.collected_lambdas)

    assert_equal('#', map2.get_at(0, 0))
    assert_equal('R', map2.get_at(1, 3), "map:\n" + map2.to_s)
    assert_equal('\\', map2.get_at(3, 2))

    assert_equal(2, map2.lift_x)
    assert_equal(0, map2.lift_y)

    assert !(map1 == map2), 'Maps should be equal'
  end
end
