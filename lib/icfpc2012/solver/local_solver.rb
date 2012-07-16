require 'set'

module Icfpc2012
  # "Local region" solver
  class LocalSolver
    attr_reader :map, :region, :target, :max_depth

    def initialize(map, region, target, max_depth=-1)
      @map = map
      @region = region.is_a?(Array) ? Region.new(*region) : region
      @target = target.is_a?(Array) ? SolverTarget.new(target) : target
      @max_depth = max_depth
    end

    def solve
      raise "Abstract class!"
    end

  end
end