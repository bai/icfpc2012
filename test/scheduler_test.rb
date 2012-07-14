require File.expand_path('../test_helper', __FILE__)

class PathFinderTest < Test::Unit::TestCase
  def get_mapfile(file)
    File.read(File.join(File.dirname(__FILE__), '../maps/', file))
  end

  def test_wave
    map1 = Icfpc2012::Map.new(get_mapfile('contest1.map.txt'))
    sc = Icfpc2012::Scheduler.new(map1)
    assert_equal(sc.solve, ["DLRDDUULLLDDL", 212])

  end

end