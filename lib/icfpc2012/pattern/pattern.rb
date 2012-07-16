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

    def cell_is?(x, y, map_cell)
      #puts "cell_is: trying #{[x, y, map_cell]}"
      match_sym?(map_cell, get_at(x, y))
    end

    # returns string of moves if matched or nil
    def match?(map, x, y)
      #puts "trying on #{[x, y]}, map:"
      #print_map_patch(map, x, y)

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
    # * - rocks and horocks
    # # - wall, beard,razor, lift , trampolines, target AND earth - all that stops rocks
    def match_sym?(map_char, pattern_char)
      (pattern_char == '?') ||
          (pattern_char == nil) ||
          (pattern_char == map_char) ||
          (pattern_char.match(/[pex]/) && map_char.match(/! \.\\OR/)) ||
          (pattern_char == "*" && pattern_char == "@") ||
          (pattern_char == '#' && map_char.match(/W!LOA-I0-9\./)) ||
          (pattern_char == 'L' && map_char == 'O')
    end

    def path_for_exit(x, y)
      raise "Not an exit cell (#{x}, #{y})!"  unless get_at(x, y) == 'x'
      path_index = 0

      (0..width-1).each do |ax|
        (0..height-1).each do |ay|
          return paths[path_index]  if x == ax && y == ay
          path_index += 1  if get_at(ax, ay) == 'x'
        end
      end

    end

    private

    # Debug printing
    def print_map_patch(map, x, y)
      (y + height - 1).downto(y) do |my|
        (x..(x + width - 1)).each do |mx|
          putc map.get_at(mx, my)
        end
        puts
      end
    end

  end
end