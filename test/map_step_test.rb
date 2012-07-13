require_relative "./test_helper"

class MapStepTest < Test::Unit::TestCase
  def setup
    # Do nothing
  end

  def teardown
    # Do nothing
  end

  # Fake test
  def test_step_simple
    map1_string = <<EOS
#####
#*.\\#
#   #
#####
EOS
    map1 = Map.new(map1_string)

    map2 = map1.step('W')

    assert_equal(0, map1.score)
    assert_equal(-1, map2.score)

    assert_equal('*', map1.get_at(1, 1))
    assert_equal(' ', map1.get_at(1, 1))
    assert_equal(' ', map2.get_at(1, 1))
    assert_equal('*', map2.get_at(1, 1))

  end

end