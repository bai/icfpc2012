require File.expand_path('../test_helper', __FILE__)

class SchedulerTest < Test::Unit::TestCase
  def get_mapfile(file)
    File.read(File.join(File.dirname(__FILE__), '../maps/', file))
  end
=begin
  def test_level1
    map1 = Icfpc2012::Map.new(get_mapfile('contest1.map.txt'))
    sc = Icfpc2012::Scheduler.new(map1)
    assert_equal(sc.solve, ["DLRDDUULLLDDL", 212])

  end
=end
  def test_level3
    map1 = Icfpc2012::Map.new(get_mapfile('contest9.map.txt'))
    sc = Icfpc2012::Scheduler.new(map1)
    sc.solve
    #assert_equal(sc.solve, ["DLRDDUULLLDDL", 212])

  end

end