module Icfpc2012
  class Region
    attr_accessor :x1, :x2, :y1, :y2

    def initialize(x1, y1, x2, y2)
      raise "Invalid region: #{[x1, y1, x2, y2]}"  if (x1 >= x2) || (y1 >= y2)
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

    def in?(point)
      point[0] >= x1 && point[0] <= x2 && point[1] >= y1 && point[1] <= y2
    end

    def self.enclosing(coord_list)
      x1 = coord_list.map(&:first).min
      x2 = coord_list.map(&:first).max+1
      y1 = coord_list.map{ |a| a[1] }.min
      y2 = coord_list.map{ |a| a[1] }.max+1

      Region.new(x1, y1, x2, y2)
    end

    def expand(by)
      Region.new(@x1-by, @y1-by, @x2+by, @y2+by)
    end

    # All the points around the given region
    def points_around
      around = []
      around << (x1..x2).map do |x| [x, @y1-1] end
      around << (x1..x2).map do |x| [x, @y2+1] end
      around << (y1..y2).map do |y| [x1-1, y] end
      around << (y1..y2).map do |y| [x2+1, y] end
    end
  end
end