require_relative "./test_helper"

class MapTest < Test::Unit::TestCase
  def setup
    # Do nothing
  end

  def teardown
    # Do nothing
  end

  # Fake test
  def test_construct_simple
    map1 = Map.new("#")
    assert_equal(1, map1.width)
    assert_equal(1, map1.height)
    assert_equal(0, map1.score)
    assert_equal('#', map1.get_at(0, 0))

    # TODO: Assert that we fail if no robot or lift found

    map2_string = <<EOS
#####
#R \\#
# * #
##L##
EOS

    map2 = Map.new(map2_string)

    assert_equal(5, map2.width)
    assert_equal(4, map2.height)

    assert_equal(1, map2.robot_x)
    assert_equal(1, map2.robot_y)

    assert_equal('#', map2.get_at(0, 0))
    assert_equal('\\', map2.get_at(3, 1))

    assert_equal(3, map2.lift_x)
    assert_equal(2, map2.lift_y)

    assert !map1.map_equals(map2), 'Maps should be equal'
  end
end
