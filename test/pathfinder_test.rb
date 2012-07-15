require File.expand_path('../test_helper', __FILE__)

class PathFinderTest < Test::Unit::TestCase
  def get_mapfile(file)
    File.read(File.join(File.dirname(__FILE__), '../maps/', file))
  end
  def test_wave
    map1_string = <<EOS
####L
#*.\\#
# R #
#####
EOS
    map1 = Icfpc2012::Map.new(map1_string)
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave(map1.robot.position)
    assert_equal(pf1.get_shortest_dist_to([1, 1]), 1)
  end

  def test_shortest_path
    map1 = Icfpc2012::Map.new(get_mapfile('contest6.map.txt'))
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave(map1.robot.position)
    #pf1.print_distmap
    assert_equal(pf1.trace_shortest_path_to(pf1.enum_closest_lambdas[10]).size,
                 pf1.get_shortest_dist_to(pf1.enum_closest_lambdas[10]) + 1)
  end

  def test_commands_path
    map1 = Icfpc2012::Map.new(get_mapfile('contest3.map.txt'))
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave(map1.robot.position)
    #pf1.print_distmap
    assert_equal("RRRDDDDDLLLLLD",
                 Icfpc2012::CoordHelper.coords_to_actions(pf1.trace_shortest_path_to(pf1.enum_closest_lambdas[3])))
  end

  def test_path_invalid
    map1 = Icfpc2012::Map.new(get_mapfile('contest9.map.txt'))
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave(map1.robot.position, Icfpc2012::PathFinder::IGNORE_ROCKS)
    #pf1.print_distmap

    path = Icfpc2012::CoordHelper.coords_to_actions(pf1.trace_shortest_path_to([3, 10]))
    wp = Icfpc2012::WaypointPath.new(map1, path)
    assert_equal(false, wp.valid?)
  end

  def test_path_valid
    map1 = Icfpc2012::Map.new(get_mapfile('contest9.map.txt'))
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave(map1.robot.position, Icfpc2012::PathFinder::IGNORE_ROCKS)
    #pf1.print_distmap

    path = Icfpc2012::CoordHelper.coords_to_actions(pf1.trace_shortest_path_to([1, 1]))
    wp = Icfpc2012::WaypointPath.new(map1, path)
    assert_equal(true, wp.valid?)
  end

  def test_safe_path
    map1 = Icfpc2012::Map.new(get_mapfile('avoidrocks.map'))
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave(map1.robot.position, Icfpc2012::PathFinder::STAY_AWAY_FROM_ROCKS)
    #pf1.print_distmap
    assert_equal("RUUURURRRDDDD",
                 Icfpc2012::CoordHelper.coords_to_actions(pf1.trace_shortest_path_to(pf1.enum_closest_lambdas[0])))
  end

  def test_trampoline_path
    map1 = Icfpc2012::Map.new(get_mapfile('trampoline1.map.txt'))
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave(map1.robot.position)
    #pf1.print_distmap
    assert_equal("LDLL",
                 Icfpc2012::CoordHelper.coords_to_actions(pf1.trace_shortest_path_to(pf1.enum_closest_lambdas[0])))
  end

  def test_interrupted_path_solve

    map_string = <<-'EOS'.gsub /^.*?-/, ''
      -L#####
      -#\   #
      -##*###
      -# .  #
      -#   R#
      -######
    EOS
    map1 = Icfpc2012::Map.new(map_string)
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave(map1.robot.position, Icfpc2012::PathFinder::IGNORE_ROCKS)
    #pf1.print_distmap

    path_coords = pf1.trace_shortest_path_to(pf1.enum_closest_lambdas[0])
    path = Icfpc2012::CoordHelper.coords_to_actions(path_coords)

    #path = "LLRULUUL"

    wp = Icfpc2012::WaypointPath.new(map1, path)
    assert_equal(false, wp.valid?)
    assert_equal("LLU", wp.path)

    path_remainder_coords = path_coords.last(path.size - wp.path.size)
    assert_equal([[2, 3],  [2, 4], [1, 4]], path_remainder_coords)


    #puts path
    #puts wp.path

    #puts (path_remainder_coords).inspect

    #wp.last_map.to_s.each_line { |line| puts line }

    #wp.path

    solution = Icfpc2012::BacktrackingSolver.repair_path(wp.last_map, path_remainder_coords)
    #puts solution.inspect

    assert(solution.last_map.robot.position[1] >= 3)

    #puts wp.path + solution.path
  end

  def test_interrupted_path_solve_fail

    map_string = <<-'EOS'.gsub /^.*?-/, ''
      -L#####
      -#   R#
      -##*###
      -#**  #
      -#.. \#
      -######
    EOS
    map1 = Icfpc2012::Map.new(map_string)
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave(map1.robot.position, Icfpc2012::PathFinder::IGNORE_ROCKS)
    #pf1.print_distmap

    path_coords = pf1.trace_shortest_path_to(pf1.enum_closest_lambdas[0])
    path = Icfpc2012::CoordHelper.coords_to_actions(path_coords)

    wp = Icfpc2012::WaypointPath.new(map1, path)

    path_remainder_coords = path_coords.last(path.size - wp.path.size)


    #puts path
    #puts wp.path

    #puts (path_remainder_coords).inspect

    #wp.last_map.to_s.each_line { |line| puts line }

    #wp.path

    solution = Icfpc2012::BacktrackingSolver.repair_path(wp.last_map, path_remainder_coords)
    assert_equal(nil, solution)

  end

  def test_interrupted_path_pattern_way

    map_string = <<-'EOS'.gsub /^.*?-/, ''
      -L#####
      -#\   #
      -##*###
      -# .  #
      -#   R#
      -######
    EOS
    map1 = Icfpc2012::Map.new(map_string)
    pf1 = Icfpc2012::PathFinder.new(map1)
    pf1.do_wave(map1.robot.position, Icfpc2012::PathFinder::IGNORE_ROCKS)
    #pf1.print_distmap

    path_coords = pf1.trace_shortest_path_to(pf1.enum_closest_lambdas[0])
    path = Icfpc2012::CoordHelper.coords_to_actions(path_coords)

    #path = "LLRULUUL"

    wp = Icfpc2012::WaypointPath.new(map1, path)
    assert_equal(false, wp.valid?)
    assert_equal("LLU", wp.path)

    path_remainder_coords = path_coords.last(path.size - wp.path.size)
    assert_equal([[2, 3],  [2, 4], [1, 4]], path_remainder_coords)


    #puts path
    #puts wp.path

    #puts (path_remainder_coords).inspect

    #wp.last_map.to_s.each_line { |line| puts line }

    #wp.path

    ps = Icfpc2012::PatternSolver2.new
    map = wp.last_map
    path = ps.solve(wp.last_map, path_remainder_coords[0])

    path.each_char { |m| map = map.step(m)} if path

    assert(map.robot.position == path_remainder_coords[0])
  end
  
  def test_clusterized_path
    map = Icfpc2012::Map.new(get_mapfile('contest5.map.txt'))
    pf = Icfpc2012::PathFinder.new(map)

    pf.do_wave(map.robot.position)   
    # puts '_________________________'
    # puts pf.clusters.inspect
    # puts '_________________________'

    # strictly adjasted
    # clusters = [
    #   [[3, 4], [3, 5], [3, 6], [4, 6], [5, 6], [6, 6], [7, 6], [8, 6], [9, 6]], 
    #   [[3, 8], [4, 8], [5, 8], [6, 8], [7, 8], [8, 8]], 
    #   [[6, 1]], 
    #   [[9, 1], [8, 1]]
    # ]
    # more liberal
    clusters = [
      [[3, 4], [3, 5], [3, 6], [4, 6], [3, 8], [5, 6], [4, 8], [6, 6], [5, 8], [7, 6], [6, 8], [8, 6], [7, 8], [9, 6], [8, 8]], 
      [[6, 1]], 
      [[9, 1], [8, 1]]
    ]
    assert pf.clusters == clusters, 'Search for unlimited lambda clusters failed'

    pf.max_clusters = 3
    pf.do_wave(map.robot.position)

    # strictly adjasted
    # clusters = [
    #   [[3, 4], [3, 5], [3, 6], [4, 6], [5, 6]], 
    #   [[3, 8]], 
    #   [[6, 1]]
    # ]
    # more liberal
    clusters = [
      [[3, 4], [3, 5], [3, 6], [4, 6], [3, 8], [5, 6], [4, 8], [6, 6], [5, 8], [7, 6], [6, 8], [8, 6], [7, 8], [9, 6], [8, 8]], 
      [[6, 1]], 
      [[9, 1]]
    ]
    assert pf.clusters == clusters, 'Search for limited lambda clusters failed'
  end

  def _test_clusters_for_map999
    map = Icfpc2012::Map.new(get_mapfile('map999.txt'))
    pf = Icfpc2012::PathFinder.new(map)

    pf.do_wave(map.robot.position)   
    puts '_________________________'
    puts pf.clusters.inspect
    puts '_________________________'
    assert pf.clusters == clusters, 'Search for unlimited lambda clusters on map999 failed'
  end
end
