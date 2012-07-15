require File.expand_path('../test_helper', __FILE__)

class CoordHelperTest < Test::Unit::TestCase
  def test_coords_to_actions
    coords = [
      [0, 0], [0, 1], [1, 1], [1, 0], [1, 0], [0, 0]
    ]

    path = Icfpc2012::CoordHelper.coords_to_actions coords

    assert(path == 'URDWL')
  end

  def _test_coords_to_actions_invalid # ignore after introduction of teleports
    coords = [
      [0, 0], [1, 1]
    ]

    assert_raise(RuntimeError) do 
      Icfpc2012::CoordHelper.coords_to_actions coords
    end
  end
end