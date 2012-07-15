module Icfpc2012
  class Pattern
    attr_accessor :name
    def initialize name
      @name = name
      @paths = Array.new
    end

    def body= the_body
      @body = the_body.split(/\r?\n/).map { |l| l.split(//) }.reverse
    end

    def body
      @body
    end

    def add_path the_path
      @paths.push(the_path)
    end

    def paths
      @paths
    end

    def width
      @width ||= @body.max_by(&:size).size
    end

    def height
      @height ||= @body.size
    end

    def get_at(x, y)
      #raise "#{x}, #{y}, #{body}".inspect
      if (y < 0) || (y >= @body.size)
          ' '
      elsif (x < 0) || (x >= @body[y].size)
        ' '
      else
        @body[y][x]
      end
    end

    # returns string of moves if matched or nil
    def match(map, x, y)
      (x..(x + width - 1)).each do |mx|
        (y..(y + height - 1)).each do |my|
          #puts "matching #{map.get_at(mx, my)} to #{get_at(mx-x, my-y)}"
          return false unless match_sym?(map.get_at(mx, my), get_at(mx-x, my-y))
        end
      end
      true
    end

    # Pattern syntax:
    # Valid map character - exact match
    # L - L or O
    # p - passable space (earth, void)
    # e - entry
    # x - exit
    # ? - anything
    def match_sym?(map_char, pattern_char)
      (pattern_char == '?') ||
          (pattern_char == nil) ||
          (pattern_char == map_char) ||
          (pattern_char.match(/[pex]/) && Map::walkable?(map_char)) ||
          (pattern_char.match(/[pex]/) && map_char == 'R') ||
          (pattern_char == 'L' && map_char == 'O')
    end
  end
end