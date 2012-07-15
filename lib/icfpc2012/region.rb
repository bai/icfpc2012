module Icfpc2012
  class Region
    attr_accessor :x1, :x2, :y1, :y2

    def initialize(x1, y1, x2, y2)
      @x1 = x1
      @x2 = x2
      @y1 = y1
      @y2 = y2
    end

    # approximate
    def center
      [(@x1+@x2)/2, (@y1+@y2)/2]
    end

    # approximate
    def radius
      [(@x2-@x1).abs, (@y2-@y1).abs].max/2+1
    end

    def self.enclosing(coord_list)
      x1 = coord_list.map(&:first).min
      x2 = coord_list.map(&:first).max
      y1 = coord_list.map(&:second).min
      y2 = coord_list.map(&:second).max

      Region.new(x1, y1, x2, y2)
    end
  end
end