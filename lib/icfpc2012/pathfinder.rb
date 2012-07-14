module Icfpc2012
  class PathFinder

    attr_accessor :map, :distmap, :lambdas

    def initialize(map)
      self.map = map

      rows, cols = map.width, map.height
      self.distmap = Array.new(cols) { Array.new(rows, -1) }
      self.lambdas = Array.new
    end

    def do_wave(coords, ignore_rocks)
      x = coords[0]
      y = coords[1]
      newFront = []
      oldFront = []
      oldFront.push [y, x]
      distmap[y][x] = 0
      t = 0

      while oldFront.length != 0 do

        oldFront.each { |c|
          ri = c[0]
          ci = c[1]

          lambdas.push [ci, ri] if map.get_at(ci, ri) == '\\'

          if distmap[ri + 1][ci] == -1 && (map.walkable?(ci, ri + 1) || (ignore_rocks && map.get_at(ci, ri + 1) == '*'))
            distmap[ri + 1][ci] = t + 1
            newFront.push [ri + 1, ci]
          end
          if distmap[ri - 1][ci] == -1 && (map.walkable?(ci, ri - 1) || (ignore_rocks && map.get_at(ci, ri - 1) == '*'))
            distmap[ri - 1][ci] = t + 1
            newFront.push [ri - 1, ci]
          end
          if distmap[ri][ci + 1] == -1 && (map.walkable?(ci + 1, ri) || (ignore_rocks && map.get_at(ci + 1, ri) == '*'))
            distmap[ri][ci + 1] = t + 1
            newFront.push [ri, ci + 1]
          end
          if distmap[ri][ci - 1] == -1 && (map.walkable?(ci - 1, ri) || (ignore_rocks && map.get_at(ci - 1, ri) == '*'))
            distmap[ri][ci - 1] = t + 1
            newFront.push [ri, ci - 1]
          end
        }
        oldFront = newFront
        newFront = []
        t += 1
      end
    end

    def enum_closest_lambdas
      lambdas
    end

    def get_shortest_dist_to(coords)
      x1 = coords[0]
      y1 = coords[1]
      distmap[y1][x1]
    end

    def trace_shortest_path_to(coords)
      path = []
      x1 = coords[0]
      y1 = coords[1]

      path.push [x1, y1]
      begin

        #puts distmap[y1][x1]

        mv = distmap[y1][x1]
        mx = x1
        my = y1
        if distmap[y1 + 1][x1] != - 1 && distmap[y1 + 1][x1] < mv
          mv = distmap[y1 + 1][x1]
          my = y1 + 1
          mx = x1
        end
        if distmap[y1 - 1][x1] != - 1 && distmap[y1 - 1][x1] < mv
          mv = distmap[y1 - 1][x1]
          my = y1 - 1
          mx = x1
        end
        if distmap[y1][x1 + 1] != - 1 && distmap[y1][x1 + 1] < mv
          mv = distmap[y1][x1 + 1]
          my = y1
          mx = x1 + 1
        end
        if distmap[y1][x1 - 1] != - 1 && distmap[y1][x1 - 1] < mv
          mv = distmap[y1][x1 - 1]
          my = y1
          mx = x1 - 1
        end
        x1 = mx
        y1 = my
        path.push [x1, y1]
        #puts [x1, y1].inspect
      end  while distmap[y1][x1] != 0
      path
    end

    def print_distmap
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

