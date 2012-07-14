require File.expand_path('../test_helper', __FILE__)

class MapStepTest < Test::Unit::TestCase
  def test_step_simple
    map1_string = <<EOS
#####
#*.\\#
# R #
#####
EOS
    map1 = Icfpc2012::Map.new(map1_string)

    map2 = map1.step('W')

    assert_equal(0, map1.score)
    assert_equal(-1, map2.score)

    assert_equal(Icfpc2012::Map::ROCK, map1.get_at(1, 2))
    assert_equal(Icfpc2012::Map::EMPTY, map1.get_at(1, 1))
    assert_equal(Icfpc2012::Map::EMPTY, map2.get_at(1, 2))
    assert_equal(Icfpc2012::Map::ROCK, map2.get_at(1, 1))
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

    map1 = Icfpc2012::Map.new(map1_string)
    map2_stepped = map1.step('W')
    map2 = Icfpc2012::Map.new(map2_string)

    assert map2 == map2_stepped
  end

  def test_step_death
    map1_string = <<EOS
#*#
# #
#R#
EOS

    map1 = Icfpc2012::Map.new(map1_string)
    map2 = map1.step('W')
    map3 = map2.step('W')

    assert(!map1.robot_dead)
    assert(!map1.robot_dead)
    #assert(map3.robot_dead)
  end

  def test_step_left
    map1_string = <<EOS
#####
#*.R#
#...#
#####
EOS
    map1 = Icfpc2012::Map.new(map1_string)

    map2 = map1.step('L')

    map2_string = <<EOS
#####
#*R #
#...#
#####
EOS

    assert map2 == Icfpc2012::Map.new(map2_string), "We should step and dig earth here\n" + map2.to_s

    map3 = map2.step('L')
    assert map3 == map2, 'We shouldn"t be able to step thru walls'

  end


end
