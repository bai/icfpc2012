module Icfpc2012
  def Icfpc2012.do_nb(c)
    opts = [ [1, 0], [-1, 0], [0, 1], [0, -1] ]
    opts.each do |p| 
      yield c[0] + p[0], c[1] + p[1]
    end
  end
    
  class PathFinder

    attr_accessor :map, :distmap, :lambdas

    def initialize(map)
      self.map = map

      rows, cols = map.width, map.height
      self.distmap = Array.new(cols) { Array.new(rows, -1) }
      self.lambdas = Array.new
    end

    STAY_AWAY_FROM_ROCKS = Proc.new do |map, nri, nci|
      # don't go anywhere near any rocks
      # probably should not test if there are any rocks
      # under the robot ???
      any_rocks = false
      Icfpc2012.do_nb ([nci, nri]) do |r, c|
        if map.get_at(r, c) == '*'
          any_rocks = true
        end
      end
      next map.walkable?(nci, nri) && !any_rocks
        
    end

    MIND_ROCKS = Proc.new do |map, nri, nci|
      # don't go through the rocks
      next map.walkable?(nci, nri)
    end
    
    IGNORE_ROCKS = Proc.new do |map, nri, nci|
      # crash right through the rocks
      next (map.walkable?(nci, nri) || map.get_at(nci, nri) == '*')
    end
    
    def do_wave(coords, policy)
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

          Icfpc2012.do_nb(c) do |nri, nci|
            if distmap[nri][nci] == -1 && policy.call(map, nri, nci)
              distmap[nri][nci] = t + 1
              newFront.push [nri, nci]
            end
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
        Icfpc2012.do_nb ([y1, x1]) do |ny, nx|
          if distmap[ny][nx] != - 1 && distmap[ny][nx] < mv
            mv = distmap[ny][nx]
            my = ny
            mx = nx
          end
        end

        x1 = mx
        y1 = my
        path.push [x1, y1]
        #puts [x1, y1].inspect
      end  while distmap[y1][x1] != 0
      path.reverse
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
