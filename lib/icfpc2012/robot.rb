module Icfpc2012
  class Robot
    attr_accessor :x, :y, :waypoints

    def initialize(x, y)
      @x = x
      @y = y
      @waypoints = [ [ x, y, nil ] ]
    end

    def step(direction)
      case direction
      when 'W' then move(0, 0, direction)  # wait
      when 'L' then move(-1, 0, direction) # move left
      when 'R' then move(1, 0, direction)  # move right
      when 'U' then move(0, 1, direction)  # move up
      when 'D' then move(0, -1, direction) # move down
      end
    end

    def position
      [ @x, @y ]
    end

    def alive?
      true
    end

    def path
      waypoints.map(&:last).join
    end

    private

    def move(dx, dy, modifier = nil)
      @waypoints << [ x, y, modifier ] # keep history of moves

      @x = @x + dx
      @y = @y + dy

      [ @x, @y ]
    end
  end
end
