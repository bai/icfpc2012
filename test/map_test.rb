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
  end
end
