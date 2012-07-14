require File.expand_path('../test_helper', __FILE__)

class PathFinderTest < Test::Unit::TestCase
  def test_wave
    map1_string = <<EOS
####L
#*.\\#
# R #
#####
EOS
    map1 = Icfpc2012::Map.new(map1_string)
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave
    #pf1.trace_distmap
  end
end