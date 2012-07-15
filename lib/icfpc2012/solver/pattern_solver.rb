require 'set'

module Icfpc2012
  class PatternSolver < LocalSolver
    def initialize(pattern_defs, map, region_center, region_radius, target_cells)
      super(map, region_center, region_radius, target_cells)
      @pattern_defs = pattern_defs
    end

    def solve
      @pattern_defs.each do |pattern|
        x1 = @region_center[0]-@region_radius
        x2 = @region_center[0]+@region_radius
        y1 = @region_center[1]-@region_radius
        y2 = @region_center[1]+@region_radius

        (x1..x2).each do |map_x|
          (y1..y2).each do |map_y|
            break  if map_x+pattern.width > x2
            break  if map_y+pattern.height > y2

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
end