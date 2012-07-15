require File.expand_path('../test_helper', __FILE__)

class DSLTest < Test::Unit::TestCase
  def test_simple
  pattern_def = <<EOS1
define_pattern ("simple1")
body <<EOS
xpx
#*#
?.p
epe
eOS
path "LRTD"
path "LRTD"

define_pattern "simple2"
body <<EOS
xpx
#*#
?.p
?pe
EOS
path "LRTD"
path "LRTD"
EOS1
  
  #map = Icfpc2012::Map.new
  defs = Icfpc2012::PatternDefs.new
  defs.load(pattern_def)
  assert_equal(2,defs.size)
  assert_equal('E',defs[0].get_at(0,0))
  assert_equal('?',defs[1].get_at(0,0))
  end
end
