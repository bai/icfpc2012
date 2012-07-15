require 'set'

module Icfpc2012
  # "Local region" solver
  class LocalSolver
    attr_reader :map, :region, :target_cells, :max_depth

    def initialize(map, region, target_cells, max_depth=-1)
      @map = map
      @region = region.is_a?(Array) ? Region.new(*region) : region
      @target_cells = target_cells
      @max_depth = max_depth
    end

    def solve
      raise "Abstract class!"
    end

    protected

    def in_region(coords)
      raise "Obsolete!"
      #@region.in?(coords)
      ## пора бы, может, перейти на объекты?
      #(@region_center[0] - coords[0]).abs < @region_radius &&
      #    (@region_center[1] - coords[1]).abs < @region_radius
    end

    def in_target(position)
      @target_cells.include?(position)
    end

  end
end