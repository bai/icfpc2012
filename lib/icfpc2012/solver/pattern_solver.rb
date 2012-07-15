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
end