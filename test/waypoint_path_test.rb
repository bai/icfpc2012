require File.expand_path('../test_helper', __FILE__)

class WaypointPathTest < Test::Unit::TestCase

  def test_stuck
    map_string = <<EOS
#R##
#  #
##L#
EOS
    path = Icfpc2012::WaypointPath.new(Icfpc2012::Map.new(map_string), 'D')
    assert(path.way_passed)

    path = Icfpc2012::WaypointPath.new(Icfpc2012::Map.new(map_string), 'L')
    assert(!path.way_passed)

  end

end