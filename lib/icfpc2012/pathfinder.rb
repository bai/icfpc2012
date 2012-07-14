module Icfpc2012
  class PathFinder

    attr_accessor :map, :distmap

    def initialize(map)
      self.map = map

      rows, cols = map.width, map.height
      self.distmap = Array.new(cols) { Array.new(rows, -1) }
    end

    def do_wave

      newFront = []
      oldFront = []
      oldFront.push [map.robot.y, map.robot.x]
      distmap[map.robot.y][map.robot.x] = 0
      t = 0;

      while oldFront.length != 0 do
        puts oldFront.length
        oldFront.each { |c|
          ri = c[0]
          ci = c[1]
          if distmap[ri + 1][ci] == -1 && map.walkable?(ci, ri + 1)
            distmap[ri + 1][ci] = t + 1
            newFront.push [ri + 1, ci]
          end
          if distmap[ri - 1][ci] == -1 && map.walkable?(ci, ri - 1)
            distmap[ri - 1][ci] = t + 1
            newFront.push [ri - 1, ci]
          end
          if distmap[ri][ci + 1] == -1 && map.walkable?(ci + 1, ri)
            distmap[ri][ci + 1] = t + 1
            newFront.push [ri, ci + 1]
          end
          if distmap[ri][ci - 1] == -1 && map.walkable?(ci - 1, ri)
            distmap[ri][ci - 1] = t + 1
            newFront.push [ri, ci - 1]
          end
        }
        oldFront = newFront
        newFront = []
        t += 1
      end

=begin
      ri = 0
      distmap.each {|r|
        ci = 0
        r.each {|c|
          if map.walkable?(ci, ri) && distmap[ri][ci] == -1
            if distmap[ri + 1][ci] != -1 distmap[ri][ci]
              distmap[ri][ci] = 2
          end
          ci+=1
        }
        ri+=1
      }
=end
    end

    def trace_distmap
      distmap.reverse.each {|r|
        r.each {|c|
          print c
          print "\t"
        }
        print "\n"
      }
    end
  end
end

