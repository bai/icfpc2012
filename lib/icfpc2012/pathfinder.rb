module Icfpc2012
  def Icfpc2012.do_nb(c)
    opts = [ [1, 0], [-1, 0], [0, 1], [0, -1] ]
    opts.each do |p|
      yield c[0] + p[0], c[1] + p[1]
    end
  end
  def Icfpc2012.do_ab(c)
    opts = [ [-1, -1], [0, -1], [1, -1],
             [-1,  0],          [1,  0],
             [-1,  1], [0,  1], [1,  1] ]
    opts.each do |p|
      yield c[0] + p[0], c[1] + p[1]
    end
  end
  def Icfpc2012.do_allb(c)
    opts = [ [-1, -1], [0, -1], [1, -1],
             [-1,  0], [0,  0], [1,  0],
             [-1,  1], [0,  1], [1,  1] ]
    opts.each do |p|
      yield c[0] + p[0], c[1] + p[1]
    end
  end
  def Icfpc2012.do_aeb(c)
    opts = [ [-1, -1], [0, -1], [1, -1],
             [-1,  0], [0,  0], [1,  0],
             [-1,  1], [0,  1], [1,  1],
             [-1,  2], [0,  2], [1,  2]]
    opts.each do |p|
      yield c[0] + p[0], c[1] + p[1]
    end
  end

  class PathFinder

    attr_accessor :map, :distmap, :lambdas, :teleport, :clusters, :razors
    attr_accessor :max_lambdas, :max_clusters

    def initialize(map)
      self.map = map
      self.max_lambdas = -1
      self.max_clusters = -1
    end

    def reset
      self.teleport = Hash.new
      rows, cols = map.width, map.height
      self.distmap = Array.new(cols) { Array.new(rows, -1) }
      self.lambdas = Array.new
      self.clusters = Array.new
      self.razors = Array.new
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
      next (map.walkable?(nci, nri) || map.get_at(nci, nri) == '*' || map.get_at(nci, nri) == 'W' || map.get_at(nci, nri) == '@')
    end

    def gval(m, c)
      if c[0] >= 0 && c[0] < m.size && c[1] >= 0 and c[1] < m[c[0]].size
        m[c[0]][c[1]]
      else
        -1
      end
    end

    def do_wave(coords, policy = MIND_ROCKS)

      reset
      x = coords[0]
      y = coords[1]
      newFront = []
      oldFront = []
      oldFront.push [y, x]
      distmap[y][x] = 0

      clusterizer = Icfpc2012::LambdaClusterizer.new @map
      t = 0

      while oldFront.length != 0 do

        oldFront.each { |c|
          ri = c[0]
          ci = c[1]

          razors.push [ci, ri] if(map.get_at(ci, ri) == '!')

          if map.get_at(ci, ri) == '\\'
            lambdas.push [ci, ri]
            clusterizer.add [ci, ri]
            self.clusters = clusterizer.clusters
            return if (max_lambdas != -1 && lambdas.size >= max_lambdas)
            # append razors so we lazily take them after we tried everything else
            if (max_clusters != -1 && clusters.size >= max_clusters)

              self.clusters.push(Array.new(1, razors[0])) if(razors.size != 0)
              return
            end
          end

          if map.jumpable?(ci, ri)
            target = map.trampolines[map.get_at(ci, ri)][1]
            c = map.trampolines[target].dup
            c[1],c[0] = c
            if gval(distmap, c) != -1
              next
            end
            teleport[c] = [ri, ci]
            distmap[c[0]][c[1]] = gval(distmap, [ri,ci])
          end
          Icfpc2012.do_nb(c) do |nri, nci|
            if gval(distmap, [nri, nci]) == -1 && policy.call(map, nri, nci)
              distmap[nri][nci] = t + 1
              newFront.push [nri, nci]
            end
          end
        }
        oldFront = newFront
        newFront = []
        t += 1
      end

      self.clusters.push(Array.new(1, razors[0])) if(razors.size != 0)
    end

    def enum_closest_lambdas
      lambdas
    end

    def enum_closest_clusters
      clusters
    end

    def get_shortest_dist_to(coords)
      gval(distmap, [coords[1], coords[0]])
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
        if teleport[[y1, x1]] != nil
          y1, x1 = teleport[[y1, x1]]
          path.push [x1, y1]
        end
        Icfpc2012.do_nb ([y1, x1]) do |ny, nx|
          if gval(distmap, [ny, nx]) != - 1 && gval(distmap, [ny, nx]) < mv
            mv = gval(distmap, [ny,nx])
            my = ny
            mx = nx
          end
        end

        return path if x1 == mx && y1 == my

        x1 = mx
        y1 = my
        path.push [x1, y1]
        #puts [x1, y1].inspect
      end  while gval(distmap, [y1, x1]) != 0
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