module Icfpc2012
  class Robot
    attr_accessor :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def step(direction)
      case direction
      when 'W' then [@x, @y] # wait
      when 'L' then [@x-1, @y] # move left
      when 'R' then [@x+1, @y] # move right
      when 'U' then [@x, @y+1] # move up
      when 'D' then [@x, @y-1] # move down
      end
    end

    def position
      [ @x, @y ]
    end

    def alive?
      true
    end
  end
end
