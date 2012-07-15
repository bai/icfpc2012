require File.expand_path('../test_helper', __FILE__)

class PatternTest < Test::Unit::TestCase
  def test_match
    map_string = <<EOS
#*###
# #R#
#*  #
#  L#
EOS
    map = Icfpc2012::Map.new(map_string)

    pattern_def = <<-'EOS'.gsub /^.*?-/, ''
define_pattern ("simple1")
body <<ENDMAP
#*
#
ENDMAP
path "LRTD"

define_pattern ("simple2")
body <<ENDMAP
xpx
#*#
?.p
epe
ENDMAP
path "LRTD"
path "LRTD"
EOS

    defs = Icfpc2012::PatternDefs.new
    defs.load(pattern_def)

    assert_equal(2, defs[0].width)
    assert_equal(2, defs[0].height)
    assert_equal(%w(LRTD), defs[0].paths)
    assert_equal(' ', defs[0].get_at(1, 0))

    assert_equal('p', defs[1].get_at(2, 1))
    assert_equal('*', defs[1].get_at(1, 2))

    assert(defs[0].match(map, 0, 0))
    assert(defs[0].match(map, 0, 2))
    assert(!defs[0].match(map, 0, 1))
    assert(!defs[0].match(map, 1, 1))

  end
end