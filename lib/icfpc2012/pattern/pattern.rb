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

    def get_at x,y
      @body[x][y]
    end

=begin
    # returns string of moves if matched or nil
    def match(map, x, y)
      [x..x + width].each do |mx|
        [y..y + height].each do |my|
           return false unless match_sym(map.get_at(mx,my)
        end
      end
      true
    end
=end

    def match_sym(x,y,sym)
      # look into fragment and match
    end
  end
end