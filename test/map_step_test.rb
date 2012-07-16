require File.expand_path('../test_helper', __FILE__)

class MapStepTest < Test::Unit::TestCase
  def test_step_simple
    map1_string = <<EOS
####L
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
###L#
#*.\\#
#  R#
#####
EOS

    map2_string = <<EOS
###L#
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
#*L
# #
#R#
EOS

    map1 = Icfpc2012::Map.new(map1_string)
    map2 = map1.step('W')

    assert(map1.robot.alive?)
    assert(!map2.robot.alive?, "Robot should be dead on map:\n#{map2.to_s}")
  end

  def test_step_left
    map1_string = <<EOS
####L
#*.R#
#...#
#####
EOS
    map1 = Icfpc2012::Map.new(map1_string)

    map2 = map1.step('L')

    map2_string = <<EOS
####L
#*R #
#...#
#####
EOS

    assert map2 == Icfpc2012::Map.new(map2_string), "We should step and dig earth here\n" + map2.to_s

    map3 = map2.step('L')
    assert map3 == map2, 'We shouldn"t be able to step thru walls'

  end

  def test_falling_twice
    map_strings = [ <<-'EOS'.gsub(/^.*?-/, ''),
          - .* **L
          -   *#..
          -  *R.*\
          - *.**.#
      EOS
      <<-'EOS'.gsub(/^.*?-/, ''),
          - .  **L
          -  **#..
          -  *R.*\
          - *.**.#
      EOS
      <<-'EOS'.gsub(/^.*?-/, ''),
            - .  **L
            -   *#..
            - **R.*\
            - *.**.#
      EOS
      <<-'EOS'.gsub(/^.*?-/, '')
            - .  **L
            -   *#..
            -  *R.*\
            -**.**.#
      EOS
    ]
    maps = map_strings.map{|s| Icfpc2012::Map.new(s)}

    assert_equal(1, maps[0].rockfall.falling_rocks.size)
    assert_equal(1, maps[1].rockfall.falling_rocks.size)
    assert_equal(1, maps[2].rockfall.falling_rocks.size)
    assert_equal(0, maps[3].rockfall.falling_rocks.size)

    maps_stepped = [ maps[0] ]
    (1..3).each do |i|
      maps_stepped << maps_stepped.last.step('W')
      assert_equal(maps[i], maps_stepped.last, "Step #{i}: ")
    end

  end

  def faq_test
    map_string = <<-'EOS'.gsub /^.*?-/, ''
      -#*. #
      -# ..#
      -# R #
      -#####
    EOS
    map = Icfpc2012::Map.new(map_string)
    assert(!map.step('L').robot.alive?)

    map_string = <<-'EOS'.gsub /^.*?-/, ''
      -#*. #
      -# R #
      -#####
    EOS
    map = Icfpc2012::Map.new(map_string)

    map = map.step('L')
    assert(map.robot.alive?)
    assert_equal('*', map.get_at(1,2))

    map_string = <<-'EOS'.gsub /^.*?-/, ''
      -#*. #
      -#R  #
      -#   #
      -#####
    EOS
    map = Icfpc2012::Map.new(map_string)
    map = map.step('D')
    assert(!map.robot.alive?)

  end
end
