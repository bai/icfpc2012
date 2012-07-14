module Icfpc2012
  class PathFinder
    def initialize(map)
      self.map = map

      rows, cols = map.width, map.height
      self.distmap = Array.new(rows) { Array.new(cols) }
    end


    end
