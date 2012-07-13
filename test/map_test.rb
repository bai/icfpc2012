require "test/unit"

class MapTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

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