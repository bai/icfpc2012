require_relative "./test_helper"

class MapStepTest < Test::Unit::TestCase
  def setup
    # Do nothing
  end

  def teardown
    # Do nothing
  end

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

  def test_step_simple_slide
    map1_string = <<EOS
#####
#*.\\#
#  R#
#####
EOS

    map2_string = <<EOS
#####
# .\\#
#* R#
#####
EOS

    map1 = Map.new(map1_string)
    map2_stepped = map1.step('W')
    map2 = Map.new(map2_string)

    assert(map2.map_equals(map2_stepped))
  end

  def test_step_death
    map1_string = <<EOS
#*#
# #
#R#
EOS

    map1 = Map.new(map1_string)
    map2 = map1.step('W')
    map3 = map2.step('W')

    assert(!map1.robot_dead)
    assert(!map1.robot_dead)
    assert(map3.robot_dead)
  end

  def test_step_left
    map1_string = <<EOS
#####
#*.R#
#...#
#####
EOS
    map1 = Map.new(map1_string)

    map2 = map1.step('L')

    map2_string = <<EOS
#####
#*R #
#...#
#####
EOS

    assert(map2.map_equals(Map.new(map2_string)), "We should step and dig earth here\n" + map2.to_s)

    map3 = map2.step('L')
    assert(map3.map_equals(map2), 'We shouldn"t be able to step thru walls')

  end


end