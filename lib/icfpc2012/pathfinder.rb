module Icfpc2012
  class PathFinder

    attr_accessor :map, :distmap

    def initialize(map)
      self.map = map

      rows, cols = map.width, map.height
      self.distmap = Array.new(cols) { Array.new(rows, 0) }
    end

    def do_wave

      distmap[map.robot.y][map.robot.x] = 1

      ri = 0
      distmap.each {|r|
        ci = 0
        r.each {|c|
          distmap[ri][ci] = 2 if map.walkable?(ci, ri)
          ci+=1
        }
        ri+=1
        print "\n"
      }
    end

    def trace_distmap
      distmap.reverse.each {|r|
        r.each {|c|
          print c
        }
        print "\n"
      }
    end
  end
end

