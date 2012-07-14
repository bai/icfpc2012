require File.expand_path('../test_helper', __FILE__)

class TraverserTest < Test::Unit::TestCase
  def test_traverse
    map1_string = <<EOS
###O#
#*.\\#
#R  #
#####
EOS
    map = Icfpc2012::Map.new(map1_string)
    
    path = Icfpc2012::Traverser.path_for(map, [[1, 1], [3, 2], [2, 3]])

    assert(path.length > 0, 'No path was found')
  end

end
