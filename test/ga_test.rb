require File.expand_path('../test_helper', __FILE__)

class GaTest < Test::Unit::TestCase
  def test_init_path
    map_string = <<EOS
#####
#*.\\#
# R #
#####
EOS
    map = Icfpc2012::Map.new(map_string)

    ga = Icfpc2012::Ga.new(1000, map)
    path = ga.init_path

    # puts '------------------------------'
    # 1000.times do
    #   path = ga.init_path
    #   puts path
    #   puts map.height + map.width
    #   puts path.length
    # end
    # puts '------------------------------'

    assert(path != nil, "No path generated")
  end
end