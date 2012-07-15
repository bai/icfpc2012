require 'set'

module Icfpc2012
  class PatternSolver < LocalSolver
    def initialize(pattern_defs, map, region, target_cells)
      super(map, region, target_cells)
      @pattern_defs = pattern_defs
    end

    def solve
      @pattern_defs.each do |pattern|
        max_x = @region.x2-pattern.width
        max_y = @region.y2-pattern.height

        (@region.x1..max_x).each do |map_x|
          (@region.y1..max_y).each do |map_y|
            if pattern.match?(@map, map_x, map_y)
              exit_cell = @target_cells.detect{ |cell| pattern.cell_is?(cell[0]-map_x, cell[1]-map_y, 'x') }
              #puts "trying #{map_x}, #{map_y} #{exit_cell}"
              if exit_cell
                best_path = pattern.path_for_exit(exit_cell[0]-map_x, exit_cell[1]-map_y)
                return best_path
              end
            end
          end
        end
      end
      nil
    end
  end

  class PatternSolver2 < LocalSolver
    def initialize
    end

    def match(pos, dir, pts, map)
      pattens = pts[dir]
      pattens.each do |offset, pdata, path|
        x1 = pos[0] + offset[0]
        y1 = pos[1] + offset[1]
        my = pdata.size - 1
        mx = pdata[0].size - 1

        puts "new"
        h = Icfpc2012::Pattern.new("aoeu")
        match = true
        (0..mx).each do |x|
          (0..my).each do |y|
            ms = map.get_at(x1 + x, y1 - y)
            ps = pdata[y][x]
            print ms, ps
            if !h.match_sym?(ms, ps)
              print [ms, ps]
              match = false
            end
          end
          puts
        end
        if match
          return path
        end
      end
      return nil
    end

    def solve(map,  desired_pos)
      pts = Hash.new
      pts[[1, 0]] = [
                     [[0,0], ["R*","ee"], "DRLUR"],
                     [[-1,0], ["eR*","?e*"], "DULRR"],
                     [[0,1], ["e?","R*", "e*"], "DUUDR"]
                    ]
      pts[[-1, 0]] = [
                      [[-1, 0], ["*R", "ee"], "DLRUL"],
                      [[-1, 0], ["*Re", "*e?"], "DURLL"],
                      [[-1, 1], ["?e", "*R", "*e"], "DUUDL"]
                     ]
      pts[[0, 1]] = [
                     [[-1, -1], ["e*",
                                 "eR"], "LURU"],
                     [[0, -1], ["*e",
                                "Re"], "RULU"],
                     [[-1, 1], ["?*",
                                "eR",
                                "ee"], "LDRLURU"],
                     [[0, 1], ["*?",
                               "Re",
                               "ee"], "RDLRULU"],
                    ]
      rpos = map.robot.position
      dir = [desired_pos[0] - rpos[0], desired_pos[1] - rpos[1]]
      match(map.robot.position, dir, pts, map)
    end
  end  
end
