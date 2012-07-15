require File.expand_path('../test_helper', __FILE__)

class PatternSolverTest < Test::Unit::TestCase

  def test_simple
    map_string = <<-'EOS'.gsub /^.*?-/, ''
      -#*#.#
      -#R. #
      -# . #
      -##L##
    EOS
    map = Icfpc2012::Map.new(map_string)

    pattern_def = <<-'EOS'.gsub /^.*?-/, ''
      -define_pattern ("simple1")
      -body <<PATTERN
      -?x?
      -. #
      -?e?
      -PATTERN

      -path "UU"
    EOS

    defs = Icfpc2012::PatternDefs.new
    defs.load(pattern_def)

    targets = [[3,2], [3,3]]
    solver = Icfpc2012::PatternSolver.new(defs, map, [3,3], 3, targets)

    path = solver.solve
    assert_equal('UU', path)
  end

  def test_complex
    map_string = File.read("#{File.dirname(__FILE__)}/../maps/contest10.map.txt")
    map = Icfpc2012::Map.new(map_string)

    pattern_def = <<-'EOS'.gsub /^.*?-/, ''
      -define_pattern ("simple1")
      -body <<PATTERN
      -###?
      -eppx
      -?**x
      -PATTERN

      -path "RRRD"
      -path "RRR"
    EOS

    defs = Icfpc2012::PatternDefs.new
    defs.load(pattern_def)

    target = [7,7]
    solver = Icfpc2012::PatternSolver.new(defs, map, [6,8], 2, [target])

    path = solver.solve
    assert_equal('RRR', path)
  end


end